//
//  ImageFilter.m
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import "ImageFilter.h"
#import "UIImage+Filter.h"
#import "CIFilter+Filter.h"
#import "CIImage+Filter.h"
#import "CIBlueMoodFilter.h"
#import <Accelerate/Accelerate.h>
#import <mach/mach_time.h>
#import <objc/message.h>

#ifndef Img
#define Img(name) [NGImage imageNamed:name]
#endif

@implementation NGImage (ImageFilter)

@dynamic filter;

- (ImageFilter*)filter {
  ImageFilter *filter = ImageFilter.new;
  filter.image = self;
  return filter;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	return [self.filter methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	return [self.filter respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation  {
	[invocation invokeWithTarget:self.filter];
}

- (NGImage *)imageToFitSize:(CGSize)fitSize method:(IFResizingMethod)resizeMethod {
	float imageScaleFactor = 1.0;
  
	if ([self respondsToSelector:@selector(scale)]) {
		imageScaleFactor = [self scale];
	}
	
  float sourceWidth = [self size].width * imageScaleFactor;
  float sourceHeight = [self size].height * imageScaleFactor;
  float targetWidth = fitSize.width;
  float targetHeight = fitSize.height;
  BOOL cropping = !(resizeMethod == IFResizeScale);
	
  // Calculate aspect ratios
  float sourceRatio = sourceWidth / sourceHeight;
  float targetRatio = targetWidth / targetHeight;
  
  // Determine what side of the source image to use for proportional scaling
  BOOL scaleWidth = (sourceRatio <= targetRatio);
  // Deal with the case of just scaling proportionally to fit, without cropping
  scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
  
  // Proportionally scale source image
  float scalingFactor, scaledWidth, scaledHeight;
  if (scaleWidth) {
    scalingFactor = 1.0 / sourceRatio;
    scaledWidth = targetWidth;
    scaledHeight = round(targetWidth * scalingFactor);
  } else {
    scalingFactor = sourceRatio;
    scaledWidth = round(targetHeight * scalingFactor);
    scaledHeight = targetHeight;
  }
  float scaleFactor = scaledHeight / sourceHeight;
  
  // Calculate compositing rectangles
  CGRect sourceRect, destRect;
  if (cropping) {
    destRect = CGRectMake(0, 0, targetWidth, targetHeight);
    float destX = 0.0f;
		float destY = 0.0f;
    if (resizeMethod == IFResizeCrop) {
      // Crop center
      destX = round((scaledWidth - targetWidth) / 2.0);
      destY = round((scaledHeight - targetHeight) / 2.0);
    } else if (resizeMethod == IFResizeCropStart) {
      // Crop top or left (prefer top)
      if (scaleWidth) {
				// Crop top
				destX = 0.0;
				destY = 0.0;
      } else {
				// Crop left
        destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
      }
    } else if (resizeMethod == IFResizeCropEnd) {
      // Crop bottom or right
      if (scaleWidth) {
				// Crop bottom
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
      } else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
      }
    }
    sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor, 
                            targetWidth / scaleFactor, targetHeight / scaleFactor);
  } else {
    sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
    destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
  }
  
  // Create appropriately modified image.
	NGImage *img = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 0.0); // 0.0 for scale means "correct scale for device's main screen".
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
		img = [NGImage imageWithCGImage:sourceImg scale:.0 orientation:self.imageOrientation]; // create cropped NGImage.
		[img drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
		CGImageRelease(sourceImg);
		img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
#endif
	if (!img) {
		// Try older method.
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, fitSize.width, fitSize.height, 8, (fitSize.width * 4), colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect);
		CGContextDrawImage(context, destRect, sourceImg);
		CGImageRelease(sourceImg);
		CGImageRef finalImage = CGBitmapContextCreateImage(context);	
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		img = [NGImage imageWithCGImage:finalImage];
		CGImageRelease(finalImage);
	}
	
  return img;
}

@end

@implementation ImageFilter

+ (void)initialize {
  id constructor = CIBlueMoodFilter.new;
  [CIFilter registerFilterName:@"CIBlueMood"
                   constructor:constructor
               classAttributes:@{kCIAttributeFilterDisplayName:@"Blue Mood Filter",
                                 kCIAttributeFilterCategories:@[kCICategoryStylize,kCICategoryStillImage]}];
}

- (NGImage*)sepia {
  return [self.image filter:@"CISepiaTone" params:@{@"inputIntensity": @0.9f}];
}

- (NGImage*)blueMood {   
  return [self.image filter:@"CIBlueMood"
                     params:@{}];
}

- (NGImage *)colorMatrix:(NSArray *)colorMatrix {
  CGFloat redVector[4]   = { [colorMatrix[0] floatValue], 0.0f, 0.0f, 0.0f };
  CGFloat greenVector[4] = { 0.0f, [colorMatrix[1] floatValue], 0.0f, 0.0f };
  CGFloat blueVector[4]  = { 0.0f, 0.0f, [colorMatrix[2] floatValue], 0.0f };
  CGFloat alphaVector[4] = { 0.0f, 0.0f, 0.0f, [colorMatrix[3] floatValue] };
  CGFloat bias = [colorMatrix[4] floatValue];
  CGFloat biasVector[4]  = { bias, bias, bias, 0.0f };
  
  
  return [self.image filter:@"CIColorMatrix"
                     params:@{@"inputRVector":   [CIVector vectorWithValues:redVector   count:4],
                              @"inputGVector":   [CIVector vectorWithValues:greenVector count:4],
                              @"inputBVector":   [CIVector vectorWithValues:blueVector  count:4],
                              @"inputAVector":   [CIVector vectorWithValues:alphaVector count:4],
                              @"inputBiasVector":[CIVector vectorWithValues:biasVector  count:4]}];
}

- (NGImage*)sunkissed {
  NGImage *img = [self colorMatrix:@[@1.f,@.6f,@.3f,@1.f,@.2f]];
  
  return [img filter:@"CIColorControls"
              params:@{@"inputBrightness": @.4f, @"inputContrast": @3.0f}];
}

- (NGImage*)polarize {
  NGImage *img = [self colorMatrix:@[@1.f,@.5f,@1.f,@1.f,@.2f]];
  
  return [img filter:@"CIColorControls" params:@{@"inputBrightness": @.4f, @"inputContrast": @3.0f}];
}

- (NGImage*)envy {   
  return [self.image filter:@"CIFalseColor"
                     params:@{@"inputColor0": [CIColor colorWithRed:.0 green:1.0 blue:.0 alpha:1.0], @"inputColor1": [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]}];
}

- (NGImage*)invert {   
  return [self.image filter:@"CIColorInvert" params:nil];
}

- (NGImage*)colorize:(float)amount {   
  return [self.image filter:@"CIColorMonochrome" params:@{@"inputIntensity": @(amount)}];
}

- (NGImage*)exposure:(float)amount {       
	return [self.image filter:@"CIExposureAdjust" params:@{@"inputEV": @(amount)}];
}

- (NGImage*)edges:(float)amount {   
  return [self.image filter:@"CIEdges" params:@{@"inputIntensity": @(amount)}];
}


- (NGImage*)brightness:(float)amount {
  return [self.image filter:@"CIColorControls"
                     params:@{@"inputBrightness": @(amount), @"inputContrast": @1.05f}];
}

- (NGImage*)brightness:(float)brightness andConstrast:(float)contrast {
  return [self.image filter:@"CIColorControls"
                     params:@{@"inputBrightness": @(brightness), @"inputContrast": @(contrast)}];
}

static unsigned char morphological_kernel[9] = {
  1, 1, 1,
  1, 1, 1,
  1, 1, 1
};

- (NGImage *)equalization {
  const size_t width = self.image.size.width;
  const size_t height = self.image.size.height;
  const size_t bytesPerRow = width * 4;
  
  CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
  CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
  CGColorSpaceRelease(space);
  if (!bmContext)
    return nil;
  
  CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.image.CGImage);
  
  UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
  if (!data) {
    CGContextRelease(bmContext);
    return nil;
  }
  
  const size_t n = sizeof(UInt8) * width * height * 4;
  void* outt = malloc(n);
  vImage_Buffer src = {data, height, width, bytesPerRow};
  vImage_Buffer dest = {outt, height, width, bytesPerRow};
  vImageDilate_ARGB8888(&src, &dest, 0, 0, morphological_kernel, 3, 3, kvImageCopyInPlace);
  
  memcpy(data, outt, n);
  
  free(outt);
  
  CGImageRef dilatedImageRef = CGBitmapContextCreateImage(bmContext);
  NGImage* dilated = [NGImage imageWithCGImage:dilatedImageRef];
  
  CGImageRelease(dilatedImageRef);
  CGContextRelease(bmContext);
  
  return dilated;
}

- (NGImage *)erode {
  const size_t width = self.image.size.width;
  const size_t height = self.image.size.height;
  const size_t bytesPerRow = width * 4;
  
  CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
  CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
  CGColorSpaceRelease(space);
  if (!bmContext)
    return nil;
  
  CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.image.CGImage);
  
  UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
  if (!data) {
    CGContextRelease(bmContext);
    return nil;
  }
  
  const size_t n = sizeof(UInt8) * width * height * 4;
  void* outt = malloc(n);
  vImage_Buffer src = {data, height, width, bytesPerRow};
  vImage_Buffer dest = {outt, height, width, bytesPerRow};
  
  vImageErode_ARGB8888(&src, &dest, 0, 0, morphological_kernel, 3, 3, kvImageCopyInPlace);
  
  memcpy(data, outt, n);
  
  free(outt);
  
  CGImageRef erodedImageRef = CGBitmapContextCreateImage(bmContext);
  NGImage* eroded = [NGImage imageWithCGImage:erodedImageRef];
  
  CGImageRelease(erodedImageRef);
  CGContextRelease(bmContext);
  
  return eroded;
}

- (NGImage*)vibrant:(float)amount {
  return [self.image filter:@"CIColorControls" params:@{kCIInputSaturationKey: @(amount*2)}];
}

- (NGImage *)sharpify {
  return [[self bloomWithRadius:1.5f andIntensity:6.f]
          blur:.6f];
}

- (NGImage*)blur:(float)amount{
  return [self.image filter:@"CIGaussianBlur" params:@{@"inputRadius": @(amount)}];
}

- (NGImage*)bloomWithRadius:(float)radius andIntensity:(float)intensity{
  return [self.image filter:@"CIBloom"
                     params:@{@"inputRadius": @(radius), @"inputIntensity": @(intensity)}];
}

- (NGImage*)gloomWithRadius:(float)radius andIntensity:(float)intensity{
  return [self.image filter:@"CIGloom"
                     params:@{@"inputRadius": @(radius), @"inputIntensity": @(intensity)}];
}

- (NGImage*)unsharpMaskWithRadius:(float)radius andIntensity:(float)intensity {
  return [self.image filter:@"CIUnsharpMask"
                     params:@{@"inputRadius": @(radius), @"inputIntensity": @(intensity)}];
}

- (NGImage*)blackAndWhite {
  return [self.image filter:@"CIColorControls" params:@{kCIInputSaturationKey: @0.0f}];
}

- (NGImage*)crossProcess {
  NGImage *img = [self.image filter:@"CIColorControls"
                             params:@{kCIInputSaturationKey: @.4f, @"inputContrast": @1.0f}];
  
  img = [img imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeScale];
  
  CIImage *backgroundImage = [CIImage imageWithCGImage:[img CGImage]];
  NGImage *i = [Img(@"crossprocess") imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeCrop];
  CIImage *inputImage = [CIImage imageWithCGImage:i.CGImage];
  return [self.image filter:@"CIOverlayBlendMode"
                     params:@{kCIInputImageKey: inputImage, kCIInputBackgroundImageKey: backgroundImage}];
}

- (NGImage*)magichour {
  NGImage *img = [self.image filter:@"CIColorControls" params:@{@"inputContrast": @1.0f}];
  img = [img imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeScale];
  CIImage *backgroundImage = [CIImage imageWithCGImage:img.CGImage];
  NGImage *i = [Img(@"magichour") imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeCrop];
  CIImage *inputImage = [CIImage imageWithCGImage:i.CGImage];
  return [self.image filter:@"CIMultiplyBlendMode"
                     params:@{kCIInputImageKey: inputImage, kCIInputBackgroundImageKey: backgroundImage}];
}


- (NGImage*)toycamera {
  CGSize size = self.image.size;
  CGFloat scale = self.image.scale;
  
  NGImage *img = [self.image imageToFitSize:CGSizeMake(size.width*scale, size.height*scale)
                                     method:IFResizeScale];
  
  CIImage *backgroundImage = [CIImage imageWithCGImage:img.CGImage];
  
  NGImage *i = [Img(@"toycamera") imageToFitSize:CGSizeMake(size.width*scale, size.height*scale)
                                          method:IFResizeCrop];
  
  CIImage *inputImage = [CIImage imageWithCGImage:i.CGImage];
  
  return [self.image filter:@"CIOverlayBlendMode"
                     params:@{kCIInputImageKey: inputImage, kCIInputBackgroundImageKey: backgroundImage}];
}


- (NGImage*)contrast:(float)amount {
  return [self.image filter:@"CIColorControls"
                     params:@{@"inputContrast": @(amount*4)}];
}

- (NGImage*)gamma:(float)amount {
  return [self.image filter:@"CIGammaAdjust"
                     params:@{@"inputPower": @(amount)}];
}

- (NGImage*)sharpen:(float)amount {
    return [self.image filter:@"CISharpenLuminance"
                       params:@{kCIInputSharpnessKey: @(amount)}];
}

- (NGImage*)posterize:(float)amount {
  return [self.image filter:@"CIColorPosterize"
                     params:@{@"inputLevels": @(amount)}];
}

- (NGImage *)filter:(NSString *)filterName params:(NSDictionary *)theParams {
  NGImage *uiImage;
  
  CIImage *image = self.image.ng_CIImage;
  
  BOOL shouldClamp = theParams.allKeys.count && theParams[@"inputRadius"];
  if (shouldClamp) {
    image = [image ng_imageByClampingToExtent];
  }
  
  CIFilter *filter = [CIFilter withName:filterName andCIImage:image];
  
  [theParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop __unused) {
    [filter setValue:obj forKey:key];
  }];
  
  CIImage* outputImage = filter.outputImage;
  
  CGRect extent = shouldClamp ? (CGRect){.size = self.image.size} : outputImage.extent;
  self.image = uiImage = [outputImage UIImageFromExtent:extent];
  
	return uiImage;
}


@end

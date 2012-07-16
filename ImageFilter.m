//
//  ImageFilter.m
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import "ImageFilter.h"
#import <CoreImage/CoreImage.h>
#import <mach/mach_time.h>
#import <objc/message.h>

#ifndef Img
#define Img(name) [UIImage imageNamed:name]
#endif

@implementation UIImage (ImageFilter)

@dynamic previousState, filter;

static UIImage* _previousState;
static ImageFilter* _filter;

- (UIImage*)previousState
{
  return _previousState?_previousState:self;
}

- (void)setPreviousState:(UIImage *)previousState
{
  _previousState = previousState;
}

- (ImageFilter*)filter
{
  if (!_filter)
  {
    _filter = ImageFilter.new;
    _filter.image = self;
  }
  return _filter;
}

- (void)setFilter:(ImageFilter *)filter
{
  _filter = filter;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
	NSMethodSignature *sig;
	sig = [self.filter methodSignatureForSelector:sel];
	return sig;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  
	return [self.filter respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation 
{
	_previousState = self;
	[invocation invokeWithTarget:self.filter];
}

- (UIImage *)imageToFitSize:(CGSize)fitSize method:(IFResizingMethod)resizeMethod {
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
	UIImage *image = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 0.0); // 0.0 for scale means "correct scale for device's main screen".
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect); // cropping happens here.
		image = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:self.imageOrientation]; // create cropped UIImage.
		[image drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
		CGImageRelease(sourceImg);
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
#endif
	if (!image) {
		// Try older method.
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, fitSize.width, fitSize.height, 8, (fitSize.width * 4), 
                                                 colorSpace, kCGImageAlphaPremultipliedLast);
		CGImageRef sourceImg = CGImageCreateWithImageInRect([self CGImage], sourceRect);
		CGContextDrawImage(context, destRect, sourceImg);
		CGImageRelease(sourceImg);
		CGImageRef finalImage = CGBitmapContextCreateImage(context);	
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		image = [UIImage imageWithCGImage:finalImage];
		CGImageRelease(finalImage);
	}
	
  return image;
}

@end

@implementation ImageFilter

- (UIImage*)sepia
{    
  return [self.image filter:@"CISepiaTone" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:0.9], @"inputIntensity", 
           nil]
          ];
}

- (UIImage*)blueMood
{    
  return [self.image filter:@"CIFalseColor" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [CIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0], @"inputColor0", 
           [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], @"inputColor1", 
           nil]
          ];
}

- (UIImage*)sunkissed
{      
  static const CGFloat redVector[4]   = { 1.f, 0.0f, 0.0f, 0.0f };
  static const CGFloat greenVector[4] = { 0.0f, .6f, 0.0f, 0.0f };
  static const CGFloat blueVector[4]  = { 0.0f, 0.0f, .3f, 0.0f };
  static const CGFloat alphaVector[4] = { 0.0f, 0.0f, 0.0f, 1.0f };
  static const CGFloat biasVector[4]  = { .2f, .2f, .2f, 0.0f };
  
  
  UIImage *image = [self.image filter:@"CIColorMatrix" params:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [CIVector vectorWithValues:redVector count:4],@"inputRVector", 
                     [CIVector vectorWithValues:greenVector count:4], @"inputGVector",
                     [CIVector vectorWithValues:blueVector count:4],@"inputBVector", 
                     [CIVector vectorWithValues:alphaVector count:4],@"inputAVector", 
                     [CIVector vectorWithValues:biasVector count:4],@"inputBiasVector", 
                     nil]
                    ];
  
  return [image filter:@"CIColorControls" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:.4], @"inputBrightness",
           [NSNumber numberWithFloat:3.0], @"inputContrast",
           nil]
          ];
}

- (UIImage*)polarize
{    
  //CIColor *marigold = [CIColor colorWithRed:216/255.0 green:166/255.0 blue:52/255.0 alpha:1.0];
  
  static const CGFloat redVector[4]   = { 1.f, 0.0f, 0.0f, 0.0f };
  static const CGFloat greenVector[4] = { 0.0f, .5f, 0.0f, 0.0f };
  static const CGFloat blueVector[4]  = { 0.0f, 0.0f, 1.f, 0.0f };
  static const CGFloat alphaVector[4] = { 0.0f, 0.0f, 0.0f, 1.0f };
  static const CGFloat biasVector[4]  = { .2f, .2f, .2f, 0.0f };
  
  
  UIImage *image = [self.image filter:@"CIColorMatrix" params:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [CIVector vectorWithValues:redVector count:4],@"inputRVector", 
                     [CIVector vectorWithValues:greenVector count:4], @"inputGVector",
                     [CIVector vectorWithValues:blueVector count:4],@"inputBVector", 
                     [CIVector vectorWithValues:alphaVector count:4],@"inputAVector", 
                     [CIVector vectorWithValues:biasVector count:4],@"inputBiasVector", 
                     nil]
                    ];
  
  return [image filter:@"CIColorControls" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:.4], @"inputBrightness",
           [NSNumber numberWithFloat:3.0], @"inputContrast",
           nil]
          ];
}

- (UIImage*)envy
{    
  return [self.image filter:@"CIFalseColor" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0], @"inputColor0", 
           [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], @"inputColor1", 
           nil]
          ];
}

- (UIImage*)invert
{    
  return [self.image filter:@"CIColorInvert" params:nil];
}

- (UIImage*)colorize:(double)amount
{    
  return [self.image filter:@"CIColorMonochrome" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:amount], @"inputIntensity", 
           nil]
          ];
}

- (UIImage*)exposure:(double)amount
{        
	return [self.image filter:@"CIExposureAdjust" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:amount], @"inputEV", 
           nil]
          ];
}

- (UIImage*)edges:(double)amount
{    
  return [self.image filter:@"CIEdges" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:amount], @"inputIntensity", 
           nil]
          ];
}


- (UIImage*)brightness:(double)amount
{
  return [self.image filter:@"CIColorControls" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:amount], @"inputBrightness", 
           nil]
          ];
}

- (UIImage*)vibrant:(double)amount
{
  amount = amount*2;
  return [self.image filter:@"CIColorControls" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:amount], @"inputSaturation", 
           nil]
          ];
}

- (UIImage*)blackAndWhite
{
  return [self.image filter:@"CIColorControls" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:0], @"inputSaturation", 
           nil]
          ];
}

- (UIImage*)crossProcess
{
  UIImage *image = [self.image filter:@"CIColorControls" params:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithFloat:.4], @"inputSaturation",
                     [NSNumber numberWithFloat:1], @"inputContrast",
                     nil]
                    ];
  
  image = [image imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeScale];
  
  CIImage *backgroundImage = [CIImage imageWithCGImage:[image CGImage]];
  UIImage *i = [Img(@"crossprocess") imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeCrop];
  CIImage *inputImage = [CIImage imageWithCGImage:[i CGImage]];
  return [self.image filter:@"CIOverlayBlendMode" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           inputImage, @"inputImage",
           backgroundImage, @"inputBackgroundImage",
           nil]
          ];
}

- (UIImage*)magichour
{
  UIImage *image = [self.image filter:@"CIColorControls" params:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithFloat:1], @"inputContrast",
                     nil]
                    ];
  image = [image imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeScale];
  CIImage *backgroundImage = [CIImage imageWithCGImage:[image CGImage]];
  UIImage *i = [Img(@"magichour") imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeCrop];
  CIImage *inputImage = [CIImage imageWithCGImage:[i CGImage]];
  return [self.image filter:@"CIMultiplyBlendMode" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           inputImage, @"inputImage",
           backgroundImage, @"inputBackgroundImage",
           nil]
          ];
}


- (UIImage*)toycamera
{
  UIImage *image = [self.image imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeScale];
  CIImage *backgroundImage = [CIImage imageWithCGImage:[image CGImage]];
  UIImage *i = [Img(@"toycamera") imageToFitSize:CGSizeMake(self.image.size.width*self.image.scale, self.image.size.height*self.image.scale) method:IFResizeCrop];
  CIImage *inputImage = [CIImage imageWithCGImage:[i CGImage]];
  return [self.image filter:@"CIOverlayBlendMode" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           inputImage, @"inputImage",
           backgroundImage, @"inputBackgroundImage",
           nil]
          ];
}


- (UIImage*)contrast:(double)amount
{
  amount = amount*4;
  return [self.image filter:@"CIColorControls" params:
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithFloat:amount], @"inputContrast", 
           nil]
          ];
}

- (UIImage *)filter:(NSString *)filterName params:(NSDictionary *)theParams {
  CIImage *beginImage = [CIImage imageWithCGImage:self.image.CGImage];
  CIContext *context = [CIContext 
                        contextWithOptions:[NSDictionary 
                                            dictionaryWithObject:[NSNumber 
                                                                  numberWithBool:NO]   forKey:kCIContextUseSoftwareRenderer]];
  CIFilter *filter = [CIFilter filterWithName:filterName];
  
  [filter setValue:beginImage forKey: kCIInputImageKey];
  
  if (theParams) {
    for (int i = 0; i<[[theParams allKeys] count]; i++) {
      [filter setValue:CFArrayGetValueAtIndex( (CFArrayRef)[theParams allValues],(CFIndex) i) 
                forKey:CFArrayGetValueAtIndex( (CFArrayRef)[theParams allKeys],(CFIndex) i) ];
    }
  }
  
  CIImage *outputImage = (CIImage *)objc_msgSend(filter, @selector(outputImage));
  
  CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
  
  UIImage *newImg = [UIImage imageWithCGImage:cgimg];
  
  CGImageRelease(cgimg);
  
	return newImg; 
}


@end

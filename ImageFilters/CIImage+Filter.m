//
//  CIImage+Filter.m
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "Platforms.h"
#import "CIImage+Filter.h"
#import "CIFilter+Filter.h"

@implementation CIImage (Filter)

- (NGImage *)UIImage {
  return [self UIImageFromExtent:self.extent];
}

- (NGImage *)UIImageFromExtent:(CGRect)extent {
  CGImageRef cgImage;
  NGImage *image;
  CIImage *ciImage = self;
 
#if isDesktop
  BOOL infinite = CGRectIsInfinite(self.extent);
  if(infinite) {
    CIVector *inputRectangle = [CIVector vectorWithCGRect:extent];
    ciImage = [CIFilter filterWithName:@"CICrop" keysAndValues:kCIInputImageKey, ciImage, @"inputRectangle", inputRectangle, nil].outputImage;
  }
  NSBitmapImageRep *rep = [NSBitmapImageRep.alloc initWithCIImage:ciImage];
  cgImage = rep.CGImage;
  image = [[NGImage alloc] initWithCGImage:cgImage size:extent.size];
  
#else
  CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer: @NO}];
  cgImage = [context createCGImage:ciImage fromRect:extent];
  image = [NGImage imageWithCGImage:cgImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
  CGImageRelease(cgImage);
  
#endif
  
  return image;
}

- (CIImage *)croppedForRadius:(float)radius {
  CIImage *image = [self ng_imageByClampingToExtent];

  CGRect extent = image.extent;
  
  CGRect cropRect = (CGRect){
    .origin.x = extent.origin.x + radius,
    .origin.y = extent.origin.y + radius,
    .size.width  = extent.size.width  - radius*2,
    .size.height = extent.size.height - radius*2
  };
  
  return [image imageByCroppingToRect:cropRect];
}

- (CIImage*)ng_imageByClampingToExtent {
  CGAffineTransform transform = CGAffineTransformIdentity;
  CIFilter *clamp = [CIFilter filterWithName:@"CIAffineClamp"];
  [clamp setValue:[NSValue valueWithBytes:&transform
                                 objCType:@encode(CGAffineTransform)]
           forKey:@"inputTransform"];
  [clamp setValue:self forKey:kCIInputImageKey];
  return [clamp valueForKey:kCIOutputImageKey];
}

@end

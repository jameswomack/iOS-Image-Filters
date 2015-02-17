//
//  UIImage+Filter.m
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "UIImage+Filter.h"
#import "Platforms.h"

@implementation NGImage (Filter)
- (CIImage*)ng_CIImage {
  return [CIImage imageWithCGImage:self.CGImage];
}

#if isDesktop
- (CGImageRef)CGImage; {
  NSGraphicsContext *context = NSGraphicsContext.currentContext;
  CGRect rect = (CGRect){.size=self.size};
  CGImageRef ref = [self CGImageForProposedRect:&rect context:context hints:NULL];
  return ref;
}

- (CGFloat)scale; {
  return 1.f;
}

+ (NGImage *)imageWithCGImage:(CGImageRef)ref {
  NGImage *image = [[NGImage alloc] initWithCGImage:ref size:CGSizeMake(CGImageGetWidth(ref), CGImageGetHeight(ref))];
  return image;
}
#endif

@end

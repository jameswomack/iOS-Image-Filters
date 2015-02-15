//
//  UIImage+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "Platforms.h"

@interface NGImage (Filter)
#if needsIOS8Features
- (CIImage*)CIImage;
#else
- (CIImage*)jw_CIImage;
#endif
#if isDesktop
- (CGImageRef)CGImage;
- (CGFloat)scale;
+ (NGImage *)imageWithCGImage:(CGImageRef)ref;
#endif
@end

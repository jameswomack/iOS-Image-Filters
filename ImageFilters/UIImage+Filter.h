//
//  UIImage+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "Platforms.h"

@interface NGImage (Filter)
- (CIImage*)ng_CIImage;
#if isDesktop
- (CGImageRef)CGImage;
- (CGFloat)scale;
+ (NGImage *)imageWithCGImage:(CGImageRef)ref;
#endif
@end

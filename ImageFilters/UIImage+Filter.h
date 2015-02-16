//
//  UIImage+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import "Platforms.h"

@interface NGImage (Filter)
- (CIImage *)CIImage;
#if isDesktop
- (CGImageRef)CGImage;
- (CGFloat)scale;
+ (NGImage *)imageWithCGImage:(CGImageRef)ref;
#endif
@end

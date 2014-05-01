//
//  CIImage+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import "Platforms.h"

@interface CIImage (Filter)
- (NGImage *)UIImage;
- (NGImage *)UIImageFromExtent:(CGRect)extent;
- (CIImage *)croppedForRadius:(float)radius;
- (CIImage*)imageByClampingToExtent;
@end

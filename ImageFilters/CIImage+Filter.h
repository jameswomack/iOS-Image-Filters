//
//  CIImage+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "Platforms.h"

@interface CIImage (Filter)
- (NGImage *)UIImage;
- (NGImage *)UIImageFromExtent:(CGRect)extent;
- (CIImage *)croppedForRadius:(float)radius;
- (CIImage*)ng_imageByClampingToExtent;
@end

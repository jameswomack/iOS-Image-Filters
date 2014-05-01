//
//  CIFilter+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import "Platforms.h"

@interface CIFilter (Filter)
+ (CIFilter *)withName:(NSString *)name andImage:(NGImage *)image;
+ (CIFilter *)withName:(NSString *)name andCIImage:(CIImage *)image;
#if isDesktop
- (CIImage *)outputImage;
#endif
@end

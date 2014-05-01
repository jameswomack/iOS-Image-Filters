//
//  CIFilter+Filter.m
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import "CIFilter+Filter.h"
#import "UIImage+Filter.h"

@implementation CIFilter (Filter)

+ (CIFilter *)withName:(NSString *)name andImage:(NGImage *)image {
  CIFilter *filter = [CIFilter filterWithName:name];
  [filter setValue:image.CIImage forKey:kCIInputImageKey];
  return filter;
}

+ (CIFilter *)withName:(NSString *)name andCIImage:(CIImage *)image {
  CIFilter *filter = [CIFilter filterWithName:name];
  [filter setValue:image forKey:kCIInputImageKey];
  return filter;
}

#if isDesktop
- (CIImage *)outputImage {
  return [self valueForKey:kCIOutputImageKey];
}
#endif

@end

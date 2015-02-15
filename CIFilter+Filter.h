//
//  CIFilter+Filter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "Platforms.h"

@interface CIFilter (Filter)
+ (CIFilter *)withName:(NSString *)name andImage:(NGImage *)image;
+ (CIFilter *)withName:(NSString *)name andCIImage:(CIImage *)image;
- (NSDictionary*)editableAttributes;
#if isDesktop
- (CIImage *)outputImage;
#else
+ (void)registerFilterName:(NSString *)name
               constructor:(id<CIFilterConstructor>)anObject
           classAttributes:(NSDictionary *)attributes;
#endif
@end

//
//  CIBlueMoodFilter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/19/14.
//

#import "Platforms.h"

@interface CIBlueMoodFilter : CIFilter
#if isDesktop
<CIFilterConstructor>
#endif

- (CIFilter *)filterWithName:(NSString *)name;

@property (nonatomic, readwrite) CIImage *inputImage;

@end

//
//  ImageFilterCache.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import <Foundation/Foundation.h>
#import "Platforms.h"

@interface ImageFilterCache : NSObject
+ (NGImage *)cached:(NGImage *)image forFilterName:(NSString *)filterName;
+ (NGImage *)cache:(NGImage *)image forFilterName:(NSString *)filterName;
+ (NSString *)keyForImage:(NGImage *)image andFilterName:(NSString *)filterName;
@end

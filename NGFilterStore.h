//
//  NGFilterStore.h
//  ImageFilterExample
//
//  Created by James Womack on 5/19/14.
//

#import <Foundation/Foundation.h>

@interface NGFilterStore : NSObject
+ (CIFilter *)filterWithName:(NSString *)name;
+ (void)registerFilterName:(NSString *)name
               constructor:(id<CIFilterConstructor>)anObject
           classAttributes:(NSDictionary *)attributes;
@end

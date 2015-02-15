//
//  ImageFilterCache.m
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "ImageFilterCache.h"

@implementation ImageFilterCache

static NSCache *cache;

+ (void)initialize {
  cache = NSCache.new;
}

+ (NGImage *)cached:(NGImage *)image forFilterName:(NSString *)filterName {
  NSString *keyForImage = [self keyForImage:image andFilterName:filterName];
  return [cache objectForKey:keyForImage];
}

+ (NGImage *)cache:(NGImage *)image forFilterName:(NSString *)filterName {
  NSString *keyForImage = [self keyForImage:image andFilterName:filterName];
  [cache setObject:image forKey:keyForImage];
  return image;
}

+ (NSString *)keyForImage:(NGImage *)__unused image andFilterName:(NSString *)filterName {
  return [NSString stringWithFormat:@"%@", filterName];
}

@end

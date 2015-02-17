//
//  NGFilterStore.m
//  ImageFilterExample
//
//  Created by James Womack on 5/19/14.
//

#import "NGFilterStore.h"
#import "Platforms.h"
#import "NGFilterConstructor.h"

static NSMutableDictionary *_backingStore;

@implementation NGFilterStore

+ (void)initialize {
  _backingStore = NSMutableDictionary.new;
}

+ (CIFilter *)filterWithName:(NSString *)name {
  NGFilterConstructor *fc = [_backingStore objectForKey:name];
  CIFilter *filter = [fc.constructor filterWithName:name];
  return filter;
}

+ (void)registerFilterName:(NSString *)name
               constructor:(id<CIFilterConstructor>)anObject
           classAttributes:(NSDictionary *)attributes {
  NGFilterConstructor *fc = NGFilterConstructor.new;
  // TODO — figure out what to do with attributes
  fc.attributes = attributes;
  fc.constructor = anObject;
  [_backingStore setObject:fc forKey:name];
}

@end

//
//  NGFilter.m
//  ImageFilterExample
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//


#import "NGFilter.h"


#define NG_FILTER                 @"NGFilter"
#define NG_FILTER_EXCEPTION(m)    [NSString stringWithFormat:@"%@%@",NG_FILTER,m]
#define NG_FILTER_EXCEPTION_R(m)  @"%@ %@",NG_FILTER,m
#define INPUT_IMAGE_EXCEPTION     NG_FILTER_EXCEPTION(   @"InputImageException" )
#define INPUT_IMAGE_EXCEPTION_R   NG_FILTER_EXCEPTION_R( @"a nil inputImage was passed" )


@implementation NGFilter {
  CIImage   *_inputImage;
  CIFilter  *_filter;
  NSCache   *_filterResultCache;
}


+ (CIFilter *)filterWithName:(NSString *)name {
  return self.new;
}


@synthesize inputImage = _inputImage;


- (void)setInputImage:(CIImage *)inputImage {
  !inputImage && [self raiseInputImageException];
  _inputImage = inputImage.copy;
  [self.filter setValue:_inputImage forKey:kCIInputImageKey];
  !self.keepPreviousImages && [self clearCache];
}


- (CIImage *)inputImage {
  return _inputImage;
}


- (BOOL)raiseInputImageException {
  [NSException raise:INPUT_IMAGE_EXCEPTION format:INPUT_IMAGE_EXCEPTION_R];
  return YES;
}


- (CIFilter *)filter {
  !_filter && (_filter = [CIFilter filterWithName:@"CIGaussianBlur"]);
  [_filter setValue:_inputImage forKey:kCIInputImageKey];
  return _filter;
}


- (NSCache *)filterResultCache {
  !_filterResultCache && (_filterResultCache = NSCache.new);
  return _filterResultCache;
}


- (BOOL)clearCache {
  [self.filterResultCache removeAllObjects];
  return YES;
}


- (NSDictionary *)keysAndValues {
  return @{kCIInputRadiusKey: @(20.f), kCIInputImageKey: _inputImage};
}


- (void)applyKeysAndValues {
  [self.keysAndValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [self.filter setValue:obj forKey:key];
  }];
}

- (id)valueForKey:(NSString *)key {
  if ([self.keysAndValues objectForKey:key]) {
    return [self.keysAndValues objectForKey:key];
  }
  return [super valueForKey:key];
}


- (NSString *)filterCacheKeyForCurrentState {
  NSUInteger inputImageHash = self.inputImage.hash;
  NSUInteger inputRadiusHash = [[self valueForKey:kCIInputRadiusKey] hash];
  return [NSString stringWithFormat:@"%i_%i",inputImageHash,inputRadiusHash];
}


- (CIImage *)getSetCachedFilterOutput:(NSString *)filterCacheKeyForCurrentState {
  CIImage *outputImage;
  
  if (!(outputImage = [self.filterResultCache objectForKey:filterCacheKeyForCurrentState])) {
    outputImage = self.filter.outputImage;
    [self.filterResultCache setObject:outputImage forKey:filterCacheKeyForCurrentState];
  }
  
  return outputImage;
}


- (CIImage *)outputImage {
  return [self getSetCachedFilterOutput:self.filterCacheKeyForCurrentState];
}


@end

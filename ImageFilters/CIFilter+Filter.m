//
//  CIFilter+Filter.m
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#import "CIFilter+Filter.h"
#import "UIImage+Filter.h"
#import "NGFilterStore.h"
#import <objc/runtime.h>

#define UNEDITABLE_KEYS @"CIAttributeFilterCategories",@"CIAttributeFilterDisplayName",@"inputImage",@"outputImage"

@implementation CIFilter (Filter)

+ (CIFilter *)withName:(NSString *)name andImage:(NGImage *)image {
  CIFilter *filter = [self filterWithName:name];

  CIImage *ciImage = image.ng_CIImage;

  [filter setValue:ciImage forKey:kCIInputImageKey];
  return filter;
}

+ (CIFilter *)withName:(NSString *)name andCIImage:(CIImage *)image {
  CIFilter *filter = [self filterWithName:name];
  [filter setValue:image forKey:kCIInputImageKey];
  return filter;
}

- (NSDictionary*)editableAttributes
{
  NSSet *uneditableAttributes = [NSSet setWithObjects:UNEDITABLE_KEYS,nil];

  NSMutableDictionary *editableAttributes = self.attributes.mutableCopy;
  
  for (NSString *key in self.attributes) {
    if ([uneditableAttributes containsObject:key]
        || ![self.attributes[key] isKindOfClass:NSDictionary.class])
      [editableAttributes removeObjectForKey:key];
  }
  
  return editableAttributes;
}

#if isDesktop
- (CIImage *)outputImage {
  return [self valueForKey:kCIOutputImageKey];
}
#else

void swizzle(Class class, SEL originalSelector, SEL swizzledSelector);
void swizzle(Class class, SEL originalSelector, SEL swizzledSelector) {
  Method originalMethod = class_getClassMethod(class, originalSelector);
  Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
  
  BOOL didAddMethod =
  class_addMethod(class,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = object_getClass((id)self);

    swizzle(class, @selector(filterWithName:), @selector(Filter_filterWithName:));
  });
}

+ (CIFilter *)Filter_filterWithName:(NSString *)name {
  CIFilter *filter = nil;
  
  if (!(filter = [self Filter_filterWithName:name])) {
    filter = [NGFilterStore filterWithName:name];
  }
  
  return filter;
}

+ (void)registerFilterName:(NSString *)name
               constructor:(id<CIFilterConstructor>)anObject
           classAttributes:(NSDictionary *)attributes {
  return [NGFilterStore registerFilterName:name constructor:anObject classAttributes:attributes];;
}
#endif

@end

//
//  CIBlueMoodFilter.m
//  ImageFilterExample
//
//  Created by James Womack on 5/19/14.
//

#import "CIBlueMoodFilter.h"
#import "UIImage+Filter.h"
#import "CIImage+Filter.h"
#import "ImageFilter.h"

@implementation CIBlueMoodFilter

- (CIImage *)outputImage {
  CIImage *image = [self valueForKey:kCIInputImageKey];
  NGImage *uiImage = [image UIImage];
  uiImage = [uiImage filter:@"CIFalseColor"
                     params:@{@"inputColor0":[CIColor colorWithRed:.0 green:.0 blue:1.0 alpha:1.0], @"inputColor1": [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]}];

  CIImage *ciImage = uiImage.ng_CIImage;
  return ciImage;
}

- (CIFilter *)filterWithName:(NSString *)__unused name {
  return self.class.new;
}

@end

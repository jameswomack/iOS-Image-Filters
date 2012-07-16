//
//  ImageFilter.h
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

@class ImageFilter;

typedef enum {
  IFResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
  IFResizeCropStart,
  IFResizeCropEnd,
  IFResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} IFResizingMethod;

@interface UIImage (ImageFilter)

/* Filters */
- (UIImage*)sepia;
- (UIImage*)invert;
- (UIImage*)vibrant:(double)amount;
- (UIImage*)colorize:(double)amount;
- (UIImage*)brightness:(double)amount;
- (UIImage*)exposure:(double)amount;
- (UIImage*)contrast:(double)amount;
- (UIImage*)edges:(double)amount;
- (UIImage*)blueMood;
- (UIImage*)sunkissed;
- (UIImage*)blackAndWhite;
- (UIImage*)crossProcess;
- (UIImage*)polarize;
- (UIImage*)magichour;
- (UIImage*)toycamera;
- (UIImage*)envy;
- (UIImage *)filter:(NSString *)filterName params:(NSDictionary *)theParams;
- (UIImage *)imageToFitSize:(CGSize)fitSize method:(IFResizingMethod)resizeMethod;

@property (weak) UIImage* previousState;
@property (strong) ImageFilter* filter;

@end

@interface ImageFilter : NSObject

@property (weak) UIImage* image;

@end

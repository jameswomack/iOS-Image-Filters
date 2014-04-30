//
//  ImageFilter.h
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>


typedef enum {
  IFResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
  IFResizeCropStart,
  IFResizeCropEnd,
  IFResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} IFResizingMethod;

@protocol NGFilterProtocol <NSObject>

/* Filters */
@optional
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
- (UIImage*)sharpen:(double)amount;
- (UIImage*)unsharpMaskWithRadius:(double)radius andIntensity:(double)intensity;
- (UIImage *)filter:(NSString *)filterName params:(NSDictionary *)theParams;
- (UIImage *)imageToFitSize:(CGSize)fitSize method:(IFResizingMethod)resizeMethod;

@end

@class ImageFilter;

@interface UIImage (ImageFilter) <NGFilterProtocol>

@property (weak, nonatomic) UIImage* previousState;
@property (strong, nonatomic) ImageFilter* filter;

@end

@interface ImageFilter : NSObject

@property (weak, nonatomic) UIImage* image;

@end

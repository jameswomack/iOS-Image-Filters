//
//  ImageFilter.h
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>
#import "Platforms.h"


typedef enum {
  IFResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
  IFResizeCropStart,
  IFResizeCropEnd,
  IFResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} IFResizingMethod;

@protocol NGFilterProtocol <NSObject>

/* Filters */
@optional
- (NGImage *)sharpify;
- (NGImage*)sepia;
- (NGImage*)invert;
- (NGImage*)vibrant:(float)amount;
- (NGImage*)colorize:(float)amount;
- (NGImage*)brightness:(float)amount;
- (NGImage*)exposure:(float)amount;
- (NGImage*)contrast:(float)amount;
- (NGImage*)edges:(float)amount;
- (NGImage*)gamma:(float)amount;
- (NGImage*)blueMood;
- (NGImage*)erode;
- (NGImage*)sunkissed;
- (NGImage*)blackAndWhite;
- (NGImage*)crossProcess;
- (NGImage*)polarize;
- (NGImage*)magichour;
- (NGImage*)toycamera;
- (NGImage*)envy;
- (NGImage*)equalization;
- (NGImage*)blur:(float)amount;
- (NGImage*)posterize:(float)amount;
- (NGImage*)sharpen:(float)amount;
- (NGImage*)unsharpMaskWithRadius:(float)radius andIntensity:(float)intensity;
- (NGImage*)gloomWithRadius:(float)radius andIntensity:(float)intensit;
- (NGImage*)bloomWithRadius:(float)radius andIntensity:(float)intensity;
- (NGImage *)filter:(NSString *)filterName params:(NSDictionary *)theParams;
- (NGImage *)imageToFitSize:(CGSize)fitSize method:(IFResizingMethod)resizeMethod;

@end

@class ImageFilter;

@interface NGImage (ImageFilter) <NGFilterProtocol>

@property (strong, nonatomic, readonly) ImageFilter* filter;

@end

@interface ImageFilter : NSObject

@property (weak, nonatomic) NGImage* image;

@end

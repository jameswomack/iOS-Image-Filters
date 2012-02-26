//
//  ImageFilter.h
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>
#import "CCMacros.h"

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

@end

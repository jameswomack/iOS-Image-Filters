//
//  ImageFilter.m
//
//  Created by James Womack on 08/23/11.
//  Copyright 2011 Cirrostratus Co.
//
//  Licensed under the MIT License.
//

#import "ImageFilter.h"
#import "UIImage+ProportionalFill.h"
#import <CoreImage/CoreImage.h>
#import <mach/mach_time.h>
#import <objc/message.h>

@implementation UIImage (ImageFilter)

#pragma mark Filters

- (UIImage*)sepia
{    
    return [self filter:@"CISepiaTone" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:0.9], @"inputIntensity", 
             nil]
            ];
}

- (UIImage*)blueMood
{    
    return [self filter:@"CIFalseColor" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [CIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0], @"inputColor0", 
             [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], @"inputColor1", 
             nil]
            ];
}

- (UIImage*)sunkissed
{    
    //CIColor *marigold = [CIColor colorWithRed:216/255.0 green:166/255.0 blue:52/255.0 alpha:1.0];
    
    static const CGFloat redVector[4]   = { 1.f, 0.0f, 0.0f, 0.0f };
    static const CGFloat greenVector[4] = { 0.0f, .6f, 0.0f, 0.0f };
    static const CGFloat blueVector[4]  = { 0.0f, 0.0f, .3f, 0.0f };
    static const CGFloat alphaVector[4] = { 0.0f, 0.0f, 0.0f, 1.0f };
    static const CGFloat biasVector[4]  = { .2f, .2f, .2f, 0.0f };
    
    
    UIImage *image = [self filter:@"CIColorMatrix" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [CIVector vectorWithValues:redVector count:4],@"inputRVector", 
             [CIVector vectorWithValues:greenVector count:4], @"inputGVector",
             [CIVector vectorWithValues:blueVector count:4],@"inputBVector", 
             [CIVector vectorWithValues:alphaVector count:4],@"inputAVector", 
             [CIVector vectorWithValues:biasVector count:4],@"inputBiasVector", 
             nil]
            ];
    
    return [image filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:.4], @"inputBrightness",
             [NSNumber numberWithFloat:3.0], @"inputContrast",
             nil]
            ];
}

- (UIImage*)polarize
{    
    //CIColor *marigold = [CIColor colorWithRed:216/255.0 green:166/255.0 blue:52/255.0 alpha:1.0];
    
    static const CGFloat redVector[4]   = { 1.f, 0.0f, 0.0f, 0.0f };
    static const CGFloat greenVector[4] = { 0.0f, .5f, 0.0f, 0.0f };
    static const CGFloat blueVector[4]  = { 0.0f, 0.0f, 1.f, 0.0f };
    static const CGFloat alphaVector[4] = { 0.0f, 0.0f, 0.0f, 1.0f };
    static const CGFloat biasVector[4]  = { .2f, .2f, .2f, 0.0f };
    
    
    UIImage *image = [self filter:@"CIColorMatrix" params:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       [CIVector vectorWithValues:redVector count:4],@"inputRVector", 
                       [CIVector vectorWithValues:greenVector count:4], @"inputGVector",
                       [CIVector vectorWithValues:blueVector count:4],@"inputBVector", 
                       [CIVector vectorWithValues:alphaVector count:4],@"inputAVector", 
                       [CIVector vectorWithValues:biasVector count:4],@"inputBiasVector", 
                       nil]
                      ];
    
    return [image filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:.4], @"inputBrightness",
             [NSNumber numberWithFloat:3.0], @"inputContrast",
             nil]
            ];
}

- (UIImage*)envy
{    
    return [self filter:@"CIFalseColor" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0], @"inputColor0", 
             [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], @"inputColor1", 
             nil]
            ];
}

- (UIImage*)invert
{    
    return [self filter:@"CIColorInvert" params:nil];
}

- (UIImage*)colorize:(double)amount
{    
    return [self filter:@"CIColorMonochrome" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:amount], @"inputIntensity", 
             nil]
            ];
}

- (UIImage*)exposure:(double)amount
{        
	return [self filter:@"CIExposureAdjust" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:amount], @"inputEV", 
             nil]
            ];
}

- (UIImage*)edges:(double)amount
{    
    return [self filter:@"CIEdges" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:amount], @"inputIntensity", 
             nil]
            ];
}


- (UIImage*)brightness:(double)amount
{
    return [self filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:amount], @"inputBrightness", 
             nil]
            ];
}

- (UIImage*)vibrant:(double)amount
{
    amount = amount*2;
    return [self filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:amount], @"inputSaturation", 
             nil]
            ];
}

- (UIImage*)blackAndWhite
{
    return [self filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:0], @"inputSaturation", 
             nil]
            ];
}

- (UIImage*)crossProcess
{
    UIImage *image = [self filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:.4], @"inputSaturation",
             [NSNumber numberWithFloat:1], @"inputContrast",
             nil]
            ];
    
    image = [image imageToFitSize:CGSizeMake(self.size.width*self.scale, self.size.height*self.scale) method:MGImageResizeScale];
    
    CIImage *backgroundImage = [CIImage imageWithCGImage:[image CGImage]];
    UIImage *i = [Img(@"crossprocess") imageToFitSize:CGSizeMake(self.size.width*self.scale, self.size.height*self.scale) method:MGImageResizeCrop];
    CIImage *inputImage = [CIImage imageWithCGImage:[i CGImage]];
    return [self filter:@"CIOverlayBlendMode" params:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            inputImage, @"inputImage",
                            backgroundImage, @"inputBackgroundImage",
                            nil]
                           ];
}

- (UIImage*)magichour
{
    UIImage *image = [self filter:@"CIColorControls" params:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithFloat:1], @"inputContrast",
                       nil]
                      ];
    image = [image imageToFitSize:CGSizeMake(self.size.width*self.scale, self.size.height*self.scale) method:MGImageResizeScale];
    CIImage *backgroundImage = [CIImage imageWithCGImage:[image CGImage]];
    UIImage *i = [Img(@"magichour") imageToFitSize:CGSizeMake(self.size.width*self.scale, self.size.height*self.scale) method:MGImageResizeCrop];
    CIImage *inputImage = [CIImage imageWithCGImage:[i CGImage]];
    return [self filter:@"CIMultiplyBlendMode" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             inputImage, @"inputImage",
             backgroundImage, @"inputBackgroundImage",
             nil]
            ];
}


- (UIImage*)toycamera
{
    UIImage *image = [self imageToFitSize:CGSizeMake(self.size.width*self.scale, self.size.height*self.scale) method:MGImageResizeScale];
    CIImage *backgroundImage = [CIImage imageWithCGImage:[image CGImage]];
   UIImage *i = [Img(@"toycamera") imageToFitSize:CGSizeMake(self.size.width*self.scale, self.size.height*self.scale) method:MGImageResizeCrop];
    CIImage *inputImage = [CIImage imageWithCGImage:[i CGImage]];
    return [self filter:@"CIOverlayBlendMode" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             inputImage, @"inputImage",
             backgroundImage, @"inputBackgroundImage",
             nil]
            ];
}


- (UIImage*)contrast:(double)amount
{
    amount = amount*4;
    return [self filter:@"CIColorControls" params:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:amount], @"inputContrast", 
             nil]
            ];
}

- (UIImage *)filter:(NSString *)filterName params:(NSDictionary *)theParams {
    CIImage *beginImage = [CIImage imageWithCGImage:[self CGImage]];
    CIContext *context = [CIContext 
                          contextWithOptions:[NSDictionary 
                                              dictionaryWithObject:[NSNumber 
                                                                    numberWithBool:NO]   forKey:kCIContextUseSoftwareRenderer]];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    
    [filter setValue:beginImage forKey: kCIInputImageKey];
    
    if (theParams) {
        for (int i = 0; i<[[theParams allKeys] count]; i++) {
            [filter setValue:CFArrayGetValueAtIndex( (CFArrayRef)[theParams allValues],(CFIndex) i) 
                      forKey:CFArrayGetValueAtIndex( (CFArrayRef)[theParams allKeys],(CFIndex) i) ];
        }
    }
    
    CIImage *outputImage = (CIImage *)objc_msgSend(filter, @selector(outputImage));
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    
	return newImg; 
}


@end

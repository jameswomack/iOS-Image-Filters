//
//  NGFilter.h
//  ImageFilterExample
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface NGFilter : CIFilter
@property (nonatomic, readwrite) CIImage  *inputImage;
@property (nonatomic, assign)    BOOL     *keepPreviousImages;
- (CIImage *)outputImage;
@end

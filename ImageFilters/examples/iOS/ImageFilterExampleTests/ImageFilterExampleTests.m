//
//  ImageFilterExampleTests.m
//  ImageFilterExampleTests
//
//  Created by James Womack on 2/15/15.
//  Copyright (c) 2015 James Womack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Specta/Specta.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "ImageFilter.h"

SpecBegin(ImageFilter)

describe(@"ImageFilter", ^{    
  it(@"receive forwarding requests from UIImage instances", ^{
    UIImage *image = UIImage.new;
    ImageFilter *imageFilter = mock([ImageFilter class]);
    image.filter = imageFilter;
    
    [image blackAndWhite];
    
    [verifyCount(imageFilter, times(1)) blackAndWhite];
  });
});

SpecEnd
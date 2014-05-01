//
//  ViewController.m
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2012—2014 James Womack. All rights reserved.
//

#import "ViewController.h"
#import "ImageFilter.h"
#import "Platforms.h"

@implementation ViewController {
  NSImage *originalImage;
}

@dynamic originalImage;


- (NSImage *)originalImage {
  if (!originalImage) {
    originalImage = self.imageView.image;
  }
  return originalImage;
}

- (IBAction)sharpify:(NSButton *)sender
{
  NSImage *image = [self.originalImage copy];
  [self.imageView setImage:[image sharpify]];
  [self.imageView setNeedsDisplay];
}

- (IBAction)previousState:(NSButton *)sender
{
  self.imageView.image = self.originalImage;
  self.imageView.image.filter = nil;
}

@end

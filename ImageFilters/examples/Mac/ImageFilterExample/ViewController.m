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
  NSImage *flippedImage;
  NSImage *currentImage;
}

@dynamic originalImage, flippedImage;


- (NSImage *)originalImage {
  !originalImage && (originalImage = self.imageView.image);
  return originalImage;
}

- (NSImage *)flippedImage {
  !flippedImage && (flippedImage = [NSImage imageNamed:@"north-park_sunflower_flipped"]);
  return flippedImage;
}

- (IBAction)toggle:(NSClickGestureRecognizer *)sender
{
  if (!currentImage || [currentImage isEqual:self.flippedImage]) {
    currentImage = self.originalImage;
  }else if ([currentImage isEqual:self.originalImage]) {
    currentImage = self.flippedImage;
  }
  
  self.imageView.image = currentImage;
  [self.imageView setNeedsDisplay];
}

- (IBAction)sharpify:(NSButton *)sender
{
  self.imageView.image = self.originalImage.sharpify;
  [self.imageView setNeedsDisplay];
}

- (IBAction)previousState:(NSButton *)sender
{
  self.imageView.image = currentImage;
}

@end

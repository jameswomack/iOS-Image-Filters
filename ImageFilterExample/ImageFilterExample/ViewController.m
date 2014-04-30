//
//  ViewController.m
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2012—2014 James Womack. All rights reserved.
//

#import "ViewController.h"
#import "ImageFilter.h"

@implementation ViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (IBAction)sharpify:(UIButton *)sender
{    
  self.imageView.image = [self.imageView.image unsharpMaskWithRadius:36.f andIntensity:4.f];
  [self.imageView setNeedsDisplay];
}

- (IBAction)previousState:(UIButton *)sender
{
  self.imageView.image = self.imageView.image.previousState;
}

@end

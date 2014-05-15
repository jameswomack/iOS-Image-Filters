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

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.originalImage = self.imageView.image;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    self.imageView.image = [self resizeImageDataToView];
  });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (IBAction)filter:(UIButton *)sender
{
  UIImage *image = [self.originalImage copy];
  [self.imageView setImage:[image blueMood]];
  [self.imageView setNeedsDisplay];
}

- (IBAction)revert:(UIButton *)sender
{
  self.imageView.image = self.originalImage;
  self.imageView.image.filter = nil;
}

- (UIImage *)resizeImageDataToView {
  // If scale is 0, it'll follows the screen scale for creating the bounds
  UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, YES, self.imageView.image.scale);
  
  [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  // Get the image out of the context
  UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // Return the result
  return copied;
}

@end

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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.originalImage = self.imageView.image;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (IBAction)filter:(UIButton *)__unused sender {
  UIImage *image = [self.originalImage copy];
  dispatch_async(dispatch_get_main_queue(), ^{
    self.imageView.image = [image blueMood];
  });
}

- (IBAction)revert:(UIButton *)__unused sender {
  self.imageView.image = self.originalImage;
  self.imageView.image.filter = nil;
}

@end

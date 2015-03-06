//
//  ViewController.m
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2011—2015 James Womack. All rights reserved.
//

#import "ViewController.h"
#import <ImageFilters/ImageFilter.h>

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
  self.segControl.selectedSegmentIndex = UISegmentedControlNoSegment;
  UIImage *image = [self.originalImage copy];
  dispatch_async(dispatch_get_main_queue(), ^{
    self.imageView.image = [image crossProcess];
  });
}

- (IBAction)revert:(UIButton *)__unused sender {
  self.segControl.selectedSegmentIndex = UISegmentedControlNoSegment;
  self.imageView.image = self.originalImage;
}

- (IBAction)toggle:(UISegmentedControl *)sender {
  if (!sender.selectedSegmentIndex) {
    [self filter:nil];
  }else{
    [self revert:nil];
  }
}

@end

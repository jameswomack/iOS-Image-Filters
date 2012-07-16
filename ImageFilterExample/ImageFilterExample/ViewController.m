//
//  ViewController.m
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2012 James Womack. All rights reserved.
//

#import "ViewController.h"
#import "ImageFilter.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (IBAction)blueMood:(UIButton *)sender
{
  imageView.image = imageView.image.crossProcess;
}

- (IBAction)previousState:(UIButton *)sender
{
  imageView.image = imageView.image.previousState;
}

@end

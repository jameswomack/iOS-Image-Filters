//
//  ViewController.h
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2011—2015 James Womack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *originalImage;

- (IBAction)filter:(UIButton *)sender;
- (IBAction)revert:(UIButton *)sender;

@end

//
//  ViewController.h
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2012 James Womack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)blueMood:(UIButton *)sender;
- (IBAction)previousState:(UIButton *)sender;


@end

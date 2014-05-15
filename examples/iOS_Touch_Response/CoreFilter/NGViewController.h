//
//  NGViewController.h
//  ImageFilterExample
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *filteredImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *mainViewTapGestureRecognizer;

- (IBAction)receivedMainViewTapGesture:(UIGestureRecognizer *)gestureRecognizer;

@end

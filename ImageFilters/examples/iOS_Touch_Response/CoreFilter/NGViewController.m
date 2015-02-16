//
//  NGViewController.m
//  ImageFilterExample
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import "NGViewController.h"
#import "NGFilter.h"
#import "UIImage+Filter.h"
#import "CIFilter+Filter.h"
#import "CIImage+Filter.h"
#import "NGLayer.h"

#define DUMMY_RETURN_VALUE YES


typedef BOOL NGFilteredImageViewAnimationType;
NGFilteredImageViewAnimationType const NGFilteredImageViewAnimationTypeHide = 0;
NGFilteredImageViewAnimationType const NGFilteredImageViewAnimationTypeShow = 1;



@interface NGViewController () {
  NGFilter *_filter;
}

@property (readonly, nonatomic)  BOOL       shouldShowFilteredImageView;
@property (readwrite, nonatomic) BOOL       isAnimatingFilteredImageView;
@property (readwrite, nonatomic) BOOL       animationInProgressIsHideAnimation;
@property (strong, nonatomic)    NSNumber   *queuedFilteredImageViewAnimation;
@property (readonly, nonatomic)  NGFilter   *filter;
@end


@implementation NGViewController


@dynamic shouldShowFilteredImageView, filter;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *image = self.filter.outputImage.UIImage;
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImageView *imageView = self.filteredImageView;
      imageView.image = image;
      imageView.layer.mask = [NGLayer.alloc initWithImage:self.originalImageView.image];
    });
  });
}


- (NGFilter *)filter {
  if (!_filter) {
    _filter = (NGFilter *)[NGFilter filterWithName:nil];
    [_filter setValuesForKeysWithDictionary:@{
                                              kCIInputImageKey: self.filteredImageView.image.CIImage
                                              }];
  }
  return _filter;
}


- (IBAction)receivedMainViewTapGesture:(UIGestureRecognizer *)gestureRecognizer {
  NSAssert([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class], @"%@", @"gestureRecognizer is a tap gesture");
  
  if(!self.isAnimatingFilteredImageView) {
    self.shouldShowFilteredImageView ? [self showFilteredImageView] : [self hideFilteredImageView];
  } else if(!self.queuedFilteredImageViewAnimation) {
    self.queuedFilteredImageViewAnimation = self.animationInProgressIsHideAnimation ? @(NGFilteredImageViewAnimationTypeShow) : @(NGFilteredImageViewAnimationTypeHide);
  }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  return YES;
}

- (BOOL)shouldShowFilteredImageView {
  return self.filteredImageView.alpha == 0.f;
}

- (BOOL)animateFilteredImageViewAlpha:(CGFloat)alpha {
  [self negotiateFilteredImageViewAnimationQueueingForAlpha:alpha];
  
  [UIView animateWithDuration:.5f animations:^{
    self.isAnimatingFilteredImageView = YES;
    self.filteredImageView.alpha = alpha;
  } completion:^(BOOL finished) {
    self.isAnimatingFilteredImageView = NO;
    
    self.queuedFilteredImageViewAnimation && [self animateFilteredImageViewAlpha:(CGFloat)self.queuedFilteredImageViewAnimation.boolValue];
    self.queuedFilteredImageViewAnimation = nil;
  }];
  
  return DUMMY_RETURN_VALUE;
}

- (void)negotiateFilteredImageViewAnimationQueueingForAlpha:(CGFloat)alpha {
  NGFilteredImageViewAnimationType animationType = (NGFilteredImageViewAnimationType)floorf(alpha);
  [self shouldQueueAnimationOfType:animationType] && (self.queuedFilteredImageViewAnimation = @(animationType));
}

- (BOOL)shouldQueueAnimationOfType:(NGFilteredImageViewAnimationType)animationType {
  return self.isAnimatingFilteredImageView
         && animationType == self.animationInProgressIsHideAnimation
         && self.queuedFilteredImageViewAnimation == nil;
}

- (void)showFilteredImageView {
  [self animateFilteredImageViewAlpha:1.f];
  self.animationInProgressIsHideAnimation = NO;
}

- (void)hideFilteredImageView {
  [self animateFilteredImageViewAlpha:0.f];
  self.animationInProgressIsHideAnimation = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _filter = nil;
}

@end

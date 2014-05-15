//
//  CALayer.m
//  ImageFilterExample
//
//  Created by James Womack on 5/16/14.
//  Copyright (c) 2014 James Womack. All rights reserved.
//

#import "NGLayer.h"
#import "UIImage+Filter.h"

@interface NGLayer ()
@property (strong, nonatomic)    CIDetector *faceDetector;
@end

@implementation NGLayer

- (instancetype)initWithImage:(UIImage *)image {
  if ((self = super.init)) {;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 10, 200, 200)];
    CGPathRef pathRef = path.CGPath;
    self.path = pathRef;
  }
  return self;
}

@end

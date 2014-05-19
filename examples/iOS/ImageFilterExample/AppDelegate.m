//
//  AppDelegate.m
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2012—2014 James Womack. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageFilter.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

+ (void)initialize {
  [ImageFilter initialize];
}

@end

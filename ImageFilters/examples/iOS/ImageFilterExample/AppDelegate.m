//
//  AppDelegate.m
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2011—2015 James Womack. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageFilter.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)__unused application
didFinishLaunchingWithOptions:(NSDictionary *)__unused launchOptions {
    return YES;
}

+ (void)initialize {
  [ImageFilter initialize];
}

@end

//
//  ViewController.h
//  ImageFilterExample
//
//  Created by James Womack on 7/16/12.
//  Copyright (c) 2012—2014 James Womack. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak, nonatomic) IBOutlet NSImageView *imageView;
@property (readonly, nonatomic) NSImage *originalImage;
@property (readonly, nonatomic) NSImage *flippedImage;

- (IBAction)sharpify:(NSButton *)sender;
- (IBAction)previousState:(NSButton *)sender;
- (IBAction)toggle:(NSClickGestureRecognizer *)sender;

@end

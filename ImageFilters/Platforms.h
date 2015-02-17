//
//  Platforms.h
//  ImageFilterExample
//
//  Created by James Womack on 5/1/14.
//

#ifndef ImageFilterExample_Platforms_h
#define ImageFilterExample_Platforms_h

#if TARGET_OS_IPHONE

#define NGColor UIColor
#define NGImage UIImage
#define NGFont UIFont
#define NGBezierPath UIBezierPath
#define isMobile 1
#define isDesktop 0
#import <CoreImage/CoreImage.h>

#elif TARGET_OS_MAC && !TARGET_OS_IPHONE

#define NGColor NSColor
#define NGImage NSImage
#define NGFont NSFont
#define NGBezierPath NSBezierPath
#define isMobile 0
#define isDesktop 1
#include <QuartzCore/CoreImage.h>


#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#define hasIOS8Features 1
#define needsIOS8Features 0
#else
#define hasIOS8Features 0
#define needsIOS8Features 1
#endif

#endif

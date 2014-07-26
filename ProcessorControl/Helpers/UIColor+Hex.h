//
//  UIColor+Hex.h
//  bineditor
//
//  Created by Dan Zimmerman on 12/23/13.
//  Copyright (c) 2013 Dan Zimmerman. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#define HColor UIColor
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#define HColor NSColor
#import <AppKit/AppKit.h>
#else
#error "I don't know what you're compiling for...."
#endif

@interface HColor (Hex)

+ (instancetype)colorWithHex:(NSString *)hex NS_RETURNS_RETAINED;
- (NSString *)hex;

@end

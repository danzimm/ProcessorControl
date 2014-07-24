//
//  NSImage+invert.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/20/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Cocoa;

@interface NSImage (invert)

- (NSImage *)inverted NS_RETURNS_RETAINED;
- (NSImage *)imageTintedWithColor:(NSColor *)tint NS_RETURNS_RETAINED;

@end

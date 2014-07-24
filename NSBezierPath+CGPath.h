//
//  NSBezierPath+CGPath.h
//  controltest
//
//  Created by Dan Zimmerman on 4/22/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Cocoa;

@interface NSBezierPath (CGPath)

- (CGPathRef)CGPath CF_RETURNS_RETAINED;

@end

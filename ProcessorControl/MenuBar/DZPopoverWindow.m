//
//  PCPopoverWindow.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/21/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZPopoverWindow.h"

@implementation DZPopoverWindow

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (void)setFrame:(NSRect)frameRect {
    [self setFrame:frameRect display:YES];
}

@end

//
//  PCPopoverWindowController.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/21/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Cocoa;

#define OPEN_DURATION .15
#define CLOSE_DURATION .1

@class DZPopoverBackgroundView, DZKeyboardController;
@interface DZPopoverWindowController : NSWindowController

- (id)initWithStatusItem:(NSStatusItem *)item viewController:(NSViewController *)viewController callback:(void (^)(BOOL))cb;

@property (nonatomic, weak) IBOutlet DZPopoverBackgroundView *backgroundView;
@property (nonatomic) IBOutlet DZKeyboardController *keyboardController;
@property (nonatomic) BOOL showing;

@property (nonatomic, weak) NSViewController *viewController;
@property (nonatomic, weak) NSStatusItem *statusItem;
@property (nonatomic, copy) void (^callback)(BOOL);

@end

//
//  DZPopoverController.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;
@import AppKit;

#import "DZStatusItemViewDelegate.h"

@class DZPopoverWindowController;
@interface DZPopoverController : NSObject<DZStatusItemViewDelegate>

+ (instancetype)popoverContollerWithStatusItemImage:(NSImage *)image viewControllerClass:(Class)viewControllerClass;
- (instancetype)initWithStatusItemImage:(NSImage *)image viewControllerClass:(Class)viewControllerClass;

+ (instancetype)popoverContollerWithStatusItemImage:(NSImage *)image showingHook:(BOOL (^)(BOOL))hook;
- (instancetype)initWithStatusItemImage:(NSImage *)image showingHook:(BOOL (^)(BOOL))hook;

@property (nonatomic) NSImage *statusItemImage;
@property (nonatomic) Class viewContollerClass;
@property (nonatomic, readonly) NSStatusItem *statusItem;
@property (nonatomic, readonly) DZPopoverWindowController *windowController;
@property (nonatomic, readonly) NSViewController *viewController;
@property (nonatomic, copy) BOOL (^showingHook)(BOOL);

@property (nonatomic) BOOL showing;

@end

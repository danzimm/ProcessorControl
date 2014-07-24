//
//  PCMenuController.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;
@import AppKit;

@class DZPreferencesWindowController;
@interface PCMenuController : NSObject

- (void)updateMenu;

@property (nonatomic, weak) IBOutlet NSButton *menuButton;
@property (nonatomic) IBOutlet NSMenu *menu;

@property (nonatomic) IBOutlet NSMenuItem *startUpItem;
@property (nonatomic) IBOutlet NSMenuItem *showStatsItem;

@end

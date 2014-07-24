//
//  AppDelegate.h
//  ProcessorControl
//
//  Created by Dan Zimmerman on 7/24/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import AppKit;

@class DZPreferencesWindowController;
@interface PCAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic) IBOutlet DZPreferencesWindowController *preferencesWindowController;

@end

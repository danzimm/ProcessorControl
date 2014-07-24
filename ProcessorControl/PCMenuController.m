//
//  PCMenuController.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import QuartzCore.CoreImage;

#import "PCMenuController.h"
#import "DZStartupHelper.h"
#import "PCPreferencesController.h"
#import "PCAppDelegate.h"

#import "NSImage+invert.h"

#include "processorcontrol.h"

@implementation PCMenuController

- (void)awakeFromNib {
  [super awakeFromNib];
  [self updateMenu];
  NSImage *tinted = [self.menuButton.image imageTintedWithColor:[NSColor colorWithRed:212.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0]];
  self.menuButton.image = tinted;
}

- (void)updateMenu {
  _startUpItem.state = [DZStartupHelper startUp] ? NSOnState : NSOffState;
  _showStatsItem.state = [[PCPreferencesController sharedInstance] showStats] ? NSOnState : NSOffState;
}

- (IBAction)menued:(NSButton *)sender {
  [self.menu popUpMenuPositioningItem:self.menu.itemArray[0] atLocation:sender.frame.origin inView:sender.superview];
}

- (IBAction)toggleStartUp:(NSMenuItem *)sender {
  BOOL setting = sender.state != NSOnState;
  [DZStartupHelper setStartUp:setting];
  [self updateMenu];
}

- (IBAction)toggleHelp:(NSMenuItem *)sender {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://processorcontrol.libdz.so"]];
}

- (IBAction)toggleQuit:(NSMenuItem *)sender {
  [[NSApplication sharedApplication] terminate:self];
}

- (IBAction)toggleUninstall:(NSMenuItem *)sender {
  NSAlert *al = [[NSAlert alloc] init];
  al.messageText = @"Are you sure you want to Uninstall?";
  [al addButtonWithTitle:@"OK"];
  [al addButtonWithTitle:@"Cancel"];
  al.informativeText = @"Uninstalling will unload and delete the helper, and then quit the app. To finish uninstalling the app afterwards simply move it to the trash.";
  NSInteger button = [al runModal];
  
  if (button == NSAlertFirstButtonReturn) {
    proccontrol_uninstall(processorcontrol_port);
    [[NSApplication sharedApplication] terminate:self];
  }
}

- (IBAction)checkForUpdate:(id)sender {
  // TODO
}


- (IBAction)preferenceStats:(NSMenuItem *)sender {
  BOOL setting = sender.state != NSOnState;
  [[PCPreferencesController sharedInstance] setShowStats:setting];
  [self updateMenu];
}

@end

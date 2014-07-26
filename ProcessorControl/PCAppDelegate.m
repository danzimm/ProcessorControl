//
//  AppDelegate.m
//  ProcessorControl
//
//  Created by Dan Zimmerman on 7/24/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#include <servers/bootstrap.h>
#include "processorcontrol.h"

#import "PCAppDelegate.h"
#import "DZPrivilegedHelperController.h"

#import "DZPopoverController.h"
#import "PCMainViewController.h"

#define DAEMON_VERSION 1

@implementation PCAppDelegate {
  id _clickEventHandler;
  DZPopoverController *_popoverController;
}

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self initialize];
}

- (void)applicationDidResignActive:(NSNotification *)notification {
  [_popoverController setShowing:NO];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  [_popoverController setShowing:NO];
}

- (void)initialize {
  uint64_t version = 0;
  if (processorcontrol_error != KERN_SUCCESS || proccontrol_version(processorcontrol_port, &version) != KERN_SUCCESS || version < DAEMON_VERSION) {
    NSError *error = [DZPrivilegedHelperController installHelperWithLabel:@"im.danz.ProcessorControlServer"];
    if (error) {
      NSLog(@"Error installing helper: %@", error);
      NSAlert *al = [[NSAlert alloc] init];
      al.messageText = @"In order to continue you need to install the helper. Clicking 'OK' will attempt to reinstall it and clicking 'Cancel' will quit ProcessorControl.";
      [al addButtonWithTitle:@"OK"];
      [al addButtonWithTitle:@"Cancel"];
      NSInteger button = [al runModal];
      if (button == NSAlertFirstButtonReturn) {
        [self initialize];
      } else {
        [[NSApplication sharedApplication] terminate:self];
      }
    } else {
      kern_return_t ret = KERN_SUCCESS;
      ret = bootstrap_look_up(bootstrap_port, "proccontrol_server", &processorcontrol_port);
      processorcontrol_error = ret;
      [self initialize];
    }
  } else {
    NSLog(@"Connected to daemon version %llu", version);
    
    if (!_popoverController) {
      _popoverController = [DZPopoverController popoverContollerWithStatusItemImage:[NSImage imageNamed:@"MenuIcon"] viewControllerClass:[PCMainViewController class]];
    }
    [self.updater checkForUpdatesInBackground];
  }
}

@end

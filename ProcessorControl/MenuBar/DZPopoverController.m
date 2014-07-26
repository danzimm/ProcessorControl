//
//  DZPopoverController.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZPopoverController.h"
#import "DZStatusItemView.h"
#import "DZPopoverWindowController.h"

#import "NSImage+invert.h"

@interface NSStatusItem ()
@property (nonatomic) NSButton *button;
@end

@implementation DZPopoverController {
  NSStatusItem *_statusItem;
  NSViewController *_viewContoller;
  DZPopoverWindowController *_popoverController;
  id _clickEventHandler;
}
@dynamic statusItemImage;

+ (instancetype)popoverContollerWithStatusItemImage:(NSImage *)image viewControllerClass:(Class)viewControllerClass {
  return [[DZPopoverController alloc] initWithStatusItemImage:image viewControllerClass:viewControllerClass];
}

+ (instancetype)popoverContollerWithStatusItemImage:(NSImage *)image showingHook:(BOOL (^)(BOOL))hook {
  return [[DZPopoverController alloc] initWithStatusItemImage:image showingHook:hook];
}

- (instancetype)initWithStatusItemImage:(NSImage *)image viewControllerClass:(Class)viewControllerClass {
  if ((self = [super init]) != nil) {
    _viewContollerClass = viewControllerClass;
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    assert(_statusItem != nil);
    
    if ([_statusItem respondsToSelector:@selector(button)]) {
      [image setTemplate:YES];
      NSImage *icpy = image.inverted;
      [icpy setTemplate:YES];
      [_statusItem.button setButtonType:NSToggleButton];
      _statusItem.button.image = image;
      _statusItem.button.alternateImage = icpy;
      _statusItem.button.target = self;
      _statusItem.button.action = @selector(statusItemTapped:);

    } else {
      _statusItem.view = [[DZStatusItemView alloc] initWithImage:image delegate:self];
    }
  }
  return self;
}

- (instancetype)initWithStatusItemImage:(NSImage *)image showingHook:(BOOL (^)(BOOL))hook {
  if ((self = [super init]) != nil) {
    self.showingHook = hook;
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    assert(_statusItem != nil);
    if ([_statusItem respondsToSelector:@selector(button)]) {
      [image setTemplate:YES];
      NSImage *icpy = image.inverted;
      [icpy setTemplate:YES];
      [_statusItem.button setButtonType:NSMomentaryLightButton];
      _statusItem.button.image = image;
      _statusItem.button.alternateImage = icpy;
      _statusItem.button.target = self;
      _statusItem.button.action = @selector(statusItemTapped:);
    } else {
      _statusItem.view = [[DZStatusItemView alloc] initWithImage:image delegate:self];
    }
  }
  return self;
}

- (NSStatusItem *)statusItem {
  return _statusItem;
}

- (DZPopoverWindowController *)windowController {
  return _popoverController;
}

- (NSViewController *)viewController {
  return _viewContoller;
}

- (void)setStatusItemImage:(NSImage *)statusItemImage {
  if ([_statusItem respondsToSelector:@selector(button)]) {
    _statusItem.button.image = statusItemImage;
  } else {
    ((DZStatusItemView *)_statusItem.view).image = statusItemImage;
  }
}

- (NSImage *)statusItemImage {
  if ([_statusItem respondsToSelector:@selector(button)]) {
    return _statusItem.button.image;
  } else {
    return ((DZStatusItemView *)_statusItem.view).image;
  }
}

- (void)statusItemView:(DZStatusItemView *)statusItemView showing:(BOOL)showing {
  [self setShowing:showing];
}

- (void)statusItemTapped:(NSButton *)button {
  [self setShowing:button.state == NSOnState];
}

- (void)setShowing:(BOOL)showing {
  _showing = showing;
  if ([_statusItem respondsToSelector:@selector(button)]) {
    _statusItem.button.state = showing ? NSOnState : NSOffState;
  } else {
    [(DZStatusItemView *)_statusItem.view setShowing:showing]; // not overkill cuz 140
  }
  if (_showingHook) {
    if (!_showingHook(showing)) {
      if ([_statusItem respondsToSelector:@selector(button)]) {
        [_statusItem.button setState:NSOffState];
      } else {
        [(DZStatusItemView *)_statusItem.view setShowing:NO];
      }
      return;
    }
  }
  if (_viewContollerClass) {
    if (_showing) {
      _viewContoller = [[self.viewContollerClass alloc] init];
      _popoverController = [[DZPopoverWindowController alloc] initWithStatusItem:_statusItem viewController:_viewContoller callback:^(BOOL showing) {
        [self setShowing:NO];
      }];
      [_popoverController setShowing:YES];
      _clickEventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^(NSEvent *event) {
        [self setShowing:NO];
      }];
    } else {
      [NSEvent removeMonitor:_clickEventHandler];
      _clickEventHandler = nil;
      [_popoverController setShowing:NO];
      _popoverController = nil;
      _viewContoller = nil;
    }
  }
}

@end

//
//  PCPopoverWindowController.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/21/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZPopoverWindowController.h"
#import "DZPopoverBackgroundView.h"
#import "DZKeyboardController.h"
#import "DZKeyHandlerController.h"
#import "DZViewContollerAdditions.h"
#import "NSObject+DelayedBlock.h"

@interface NSStatusItem ()
@property (nonatomic) NSButton *button;
@end

@implementation DZPopoverWindowController

- (id)initWithStatusItem:(NSStatusItem *)item viewController:(NSViewController *)viewController callback:(void (^)(BOOL))cb {
  if ((self = [super initWithWindowNibName:@"DZPopoverWindowController"]) != nil) {
    _callback = [cb copy];
    _statusItem = item;
    _viewController = viewController;
    [self loadKeysAndCheats];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  NSPanel *panel = (id)[self window];
  [panel setAcceptsMouseMovedEvents:YES];
  [panel setLevel:NSPopUpMenuWindowLevel];
  [panel setOpaque:NO];
  [panel setBackgroundColor:[NSColor clearColor]];
  
}

- (void)setShowing:(BOOL)showing {
  if (_showing != showing) {
    _showing = showing;
    
    if (_showing) {
      [self openPanel];
    } else {
      [self closePanel];
    }
  }
}

- (void)setViewController:(NSViewController *)viewController {
  _viewController = viewController;
  [self loadKeysAndCheats];
}

- (void)setKeyboardController:(DZKeyboardController *)keyboardController {
  _keyboardController = keyboardController;
  [self loadKeysAndCheats];
}

- (void)windowWillClose:(NSNotification *)notification {
  [self setShowing:NO];
  if (_callback)
    _callback(NO);
}

- (void)windowDidResignKey:(NSNotification *)notification {
  if ([[self window] isVisible]) {
    [self setShowing:NO];
    if (_callback)
      _callback(NO);
  }
}

- (void)windowDidResize:(NSNotification *)notification {
  NSWindow *panel = [self window];
  NSRect statusRect = [self statusRectForWindow:panel];
  NSRect panelRect = [panel frame];
  
  CGFloat statusX = roundf(NSMidX(statusRect));
  CGFloat panelX = statusX - NSMinX(panelRect);
  
  self.backgroundView.arrowX = panelX;
}

- (void)cancel:(id)sender {
  [self setShowing:NO];
  if (_callback)
    _callback(NO);
}

- (void)keyDown:(NSEvent *)theEvent {} // for no more beeping

- (NSRect)statusRectForWindow:(NSWindow *)window {
  if ([_statusItem respondsToSelector:@selector(button)]) {
    return [[(NSButton *)[_statusItem performSelector:@selector(button)] window] convertRectToScreen:_statusItem.button.frame];
  } else {
    return [_statusItem.view.window convertRectToScreen:_statusItem.view.frame];
  }
}

- (void)openPanel {
  NSWindow *panel = [self window];
  [panel.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
  NSRect statusRect = [self statusRectForWindow:panel];
      
  NSView *subview = _viewController.view;
  
  NSRect panelRect = [panel frame];
  panelRect.size.width = subview.frame.size.width;
  panelRect.size.height = subview.frame.size.height + 15;
  panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
  panelRect.origin.y = NSMinY(statusRect) - NSHeight(panelRect);
  
  subview.frame = NSMakeRect(0, 5, subview.frame.size.width, subview.frame.size.height);
  [panel.contentView addSubview:subview];
  if (subview) {
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    [panel.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[subview]-5-|" options:0 metrics:nil views:views]];
    [panel.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|" options:0 metrics:nil views:views]];
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
      panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
  }
  if ([_viewController respondsToSelector:@selector(viewWillShow)])
    [_viewController performSelector:@selector(viewWillShow) withObject:nil];
  
  [NSApp activateIgnoringOtherApps:NO];
  [panel setAlphaValue:0];
  [panel setFrame:panelRect display:YES]; // switch to statusrect for ani
  [panel makeKeyAndOrderFront:nil];
  
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:OPEN_DURATION];
  [[panel animator] setAlphaValue:1];
  [NSAnimationContext endGrouping];
  [self performBlock:^(id obj) {
    if ([_viewController respondsToSelector:@selector(viewDidShow)])
      [_viewController performSelector:@selector(viewDidShow) withObject:nil];
  } withObject:nil afterDelay:OPEN_DURATION];
}

- (void)closePanel {
  if ([_viewController respondsToSelector:@selector(viewWillHide)])
    [_viewController performSelector:@selector(viewWillHide) withObject:nil];

  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
  [[self.window animator] setAlphaValue:0];
  [NSAnimationContext endGrouping];
  
  [self performBlock:^(id obj) {
    if ([_viewController respondsToSelector:@selector(viewDidHide)])
      [_viewController performSelector:@selector(viewDidHide) withObject:nil];
  } withObject:nil afterDelay:CLOSE_DURATION];
  
  dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
    [self.window orderOut:nil];
  });
}

- (void)loadKeysAndCheats {
  if (!_keyboardController)
    return;
  [_keyboardController.handlers removeAllObjects];
  if (!_viewController) {
    return;
  }
  if ([_viewController respondsToSelector:@selector(keyHandlers)]) {
    @autoreleasepool {
      NSArray *tmp = [(id <DZKeyHandlerController>)_viewController keyHandlers];
      [_keyboardController addHandlers:tmp];
      tmp = nil;
    }
  }
}

@end

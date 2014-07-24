
//
//  DZKeyHandler.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZKeyboardController.h"
#import "DZKeyHandler.h"

@implementation DZKeyboardController {
  id _keyEventHandler;
}

- (id)init {
  if ((self = [super init]) != nil) {
    _handlers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addHandler:(DZKeyHandler *)handler {
  [_handlers addObject:handler];
}

- (void)addHandlers:(NSArray *)handlers {
  [handlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([obj isKindOfClass:[DZKeyHandler class]])
      [_handlers addObject:obj];
  }];
}

- (BOOL)keyUp:(NSEvent *)event {
  __block BOOL foundOne = NO;
  [_handlers enumerateObjectsUsingBlock:^(DZKeyHandler *obj, NSUInteger idx, BOOL *stop) {
    if ([obj key:event])
      foundOne = YES;
  }];
  return foundOne;
}

- (void)awakeFromNib {
  __weak DZKeyboardController *_self = self;
  _keyEventHandler = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyUpMask handler:^NSEvent *(NSEvent *event) {
    if ([_self keyUp:event])
      return nil;
    return event;
  }];
}

- (void)dealloc {
  [NSEvent removeMonitor:_keyEventHandler];
  _keyEventHandler = nil;
  [_handlers removeAllObjects];
  _handlers = nil;
}

@end

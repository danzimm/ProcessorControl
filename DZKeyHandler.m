//
//  DZKeyHandler.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZKeyHandler.h"

@implementation DZKeyHandler

+ (instancetype)handlerWithCallback:(BOOL (^)(DZKeyHandler *self, NSEvent *event))callback {
  DZKeyHandler *ret = [[self alloc] init];
  ret.callback = callback;
  return ret;
}

- (BOOL)key:(NSEvent *)event {
  return self.callback && self.callback(self, event);
}

@end

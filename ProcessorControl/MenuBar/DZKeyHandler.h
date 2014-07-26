//
//  DZKeyHandler.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import AppKit;

@interface DZKeyHandler : NSObject

+ (instancetype)handlerWithCallback:(BOOL (^)(DZKeyHandler *self, NSEvent *event))callback;

@property (nonatomic, copy) BOOL (^callback)(DZKeyHandler *self, NSEvent *event);

- (BOOL)key:(NSEvent *)event;

@end

//
//  DZKeyHandler.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DZKeyHandler;
@interface DZKeyboardController : NSObject

- (void)addHandler:(DZKeyHandler *)handler;
- (void)addHandlers:(NSArray *)handlers;

@property (nonatomic) NSMutableArray *handlers;

@end

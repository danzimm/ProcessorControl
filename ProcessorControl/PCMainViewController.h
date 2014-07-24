//
//  PCMainViewController.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/20/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Cocoa;
#import "DZMatrixViewDelegate.h"
#import "DZKeyHandlerController.h"

@class DZMatrixView, PCMenuController;
@interface PCMainViewController : NSViewController<DZMatrixViewDelegate, DZKeyHandlerController>

@property (nonatomic, weak) IBOutlet DZMatrixView *matrix;
@property (nonatomic, weak) IBOutlet NSTextField *titleLabel;
@property (nonatomic) IBOutlet PCMenuController *menuController;

- (void)stopTimer;

@end

//
//  DZProcessorCell.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/27/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import QuartzCore.QuartzCore;
@import AppKit;
#include <mach/mach.h>

@interface DZProcessorCell : CALayer

@property (nonatomic, readonly) CATextLayer *textLayer;
@property (nonatomic, readonly) CATextLayer *subTextLayer;
@property (nonatomic) BOOL enabled;
@property (nonatomic) NSInteger switchType;
@property (nonatomic) BOOL master;
@property (nonatomic) NSUInteger row, column, rows, columns;
@property (nonatomic) BOOL touching;
@property (nonatomic) unsigned int cpu_tick_system, cpu_tick_user, cpu_tick_idle;
@property (nonatomic) BOOL showStats;

@end

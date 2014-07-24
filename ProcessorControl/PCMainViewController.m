//
//  PCMainViewController.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/20/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Darwin.Mach;
@import QuartzCore.QuartzCore;

#import "PCMainViewController.h"
#import "PCPreferencesController.h"
#import "DZProcessorCell.h"
#import "DZMatrixView.h"
#import "DZCheat.h"
#import "DZViewContollerAdditions.h"

#include "Helpers.h"
#include "processorcontrol.h"

@implementation PCMainViewController {
  processor_array_t processors;
  mach_msg_type_number_t nprocessors;
  
  NSTimer *_loadTimer;
}

#pragma mark NSViewController subclass

- (id)init {
  if ((self = [super initWithNibName:@"PCMainViewController" bundle:nil]) != nil) {
  }
  return self;
}


- (void)dealloc {
  [[PCPreferencesController sharedInstance] removeObserver:self];
  [self stopTimer]; // although this wont be called unless thats called first
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  kern_return_t ret = proccontrol_processors(processorcontrol_port, &processors, &nprocessors);
  if (ret != KERN_SUCCESS) {
    NSLog(@"Error fetching processors: %s", mach_error_string(ret));
    return;
  }
  self.matrix.cellClass = [DZProcessorCell class];

  self.matrix.columns = 2;
  self.matrix.rows = nprocessors / self.matrix.columns + (nprocessors % self.matrix.columns != 0 ? 1 : 0);
  self.matrix.interspace = CGSizeMake(15, 15);
  self.matrix.cellSize = CGSizeMake(100, 100);
  
  CGSize r = [self.matrix realSize];
  
  self.view.frame = NSMakeRect(self.view.frame.origin.x, self.view.frame.origin.y, r.width + 40, r.height + 50);
  [self updateAllSwitch];
  
  [[PCPreferencesController sharedInstance] addPotatodObserver:self];
  [[PCPreferencesController sharedInstance] addSwitchTypeObserver:self];
  [[PCPreferencesController sharedInstance] addShowStatsObserver:self];
  [self potatod];
}

#pragma mark DZViewControllerAdditions

- (void)viewWillShow {
  [self showStats];
}

- (void)viewDidHide {
  [self stopTimer];
}

#pragma mark LoadInfo

- (void)stopTimer {
  [_loadTimer invalidate];
  _loadTimer = nil;
}

- (void)updateLoadInfo {
  [self.matrix.cells enumerateObjectsUsingBlock:^(DZProcessorCell *processorCell, NSUInteger idx, BOOL *stop) {
    struct processor_cpu_load_info cpu_info;
    processor_t processor = processors[idx];
    kern_return_t ret = KERN_SUCCESS;
    if ((ret = load_info(processor, &cpu_info)) != KERN_SUCCESS)
      return;
    processorCell.cpu_tick_system = cpu_info.cpu_ticks[CPU_STATE_SYSTEM];
    processorCell.cpu_tick_user = cpu_info.cpu_ticks[CPU_STATE_USER];
    processorCell.cpu_tick_idle = cpu_info.cpu_ticks[CPU_STATE_IDLE];
  }];
}

#pragma mark DZMatrixViewDelegate

- (void)matrix:(DZMatrixView *)matrix drawLayer:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column {
  
  processor_t processor = processors[row*self.matrix.columns + column];
  struct processor_basic_info info;
  kern_return_t ret = quick_info(processor, &info);
  if (ret != KERN_SUCCESS)
    return;
  
  DZProcessorCell *processorCell = (DZProcessorCell *)cell;
  
  NSInteger switchType = [[PCPreferencesController sharedInstance] switchType];
  BOOL showStats = [[PCPreferencesController sharedInstance] showStats];
  BOOL enabled = info.running;
  BOOL master = info.is_master;
  
  processorCell.column = column;
  processorCell.row = row;
  processorCell.columns = matrix.columns;
  processorCell.rows = matrix.rows;
  processorCell.enabled = enabled;
  processorCell.master = master;
  processorCell.switchType = switchType;
  processorCell.showStats = showStats;
  
}

- (void)matrix:(DZMatrixView *)matrix mouseDown:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column {
  ((DZProcessorCell *)cell).touching = YES;
  cell.transform = CATransform3DMakeScale(0.9, 0.9, 1);
}

- (void)matrix:(DZMatrixView *)matrix mouseOut:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column {
  cell.transform = CATransform3DIdentity;
  ((DZProcessorCell *)cell).touching = NO;
}

- (void)matrix:(DZMatrixView *)matrix mouseUp:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column {
  
  cell.transform = CATransform3DIdentity;
  ((DZProcessorCell *)cell).touching = NO;
  
  processor_t processor = processors[row*self.matrix.columns + column];
  struct processor_basic_info info;
  kern_return_t ret = quick_info(processor, &info);
  if (ret != KERN_SUCCESS)
    return;
  
  BOOL master = info.is_master;
  BOOL enabled = info.running;
  
  if (!master) {
    if (enabled) {
      processor_exit(processor);
    } else {
      processor_start(processor);
    }
    ret = quick_info(processor, &info);
    if (ret != KERN_SUCCESS)
      return;
    enabled = info.running;
    ((DZProcessorCell *)cell).enabled = enabled;
    [self updateAllSwitch];
  }
}

#pragma mark DZKeyHandlerController

- (NSArray *)keyHandlers {
  return @[[DZCheat cheatWithCode:@"potato" success:^{
    [[PCPreferencesController sharedInstance] setPotatod:![[PCPreferencesController sharedInstance] potatod]];
  }], [DZCheat cheatWithCode:@"smiley" success:^{
    NSInteger i = [[PCPreferencesController sharedInstance] switchType];
    [[PCPreferencesController sharedInstance] setSwitchType:i == PCSwitchTypeSmiley ? PCSwitchTypeDefault : PCSwitchTypeSmiley];
  }]];
}

// TODO: PCPreferencesControllerDelegate
#pragma mark PCPreferencesControllerDelegate

- (void)potatod {
  BOOL enabled = [[PCPreferencesController sharedInstance] potatod];
  if (!enabled) {
    self.titleLabel.stringValue = @"Processor Control";
  } else {
    self.titleLabel.stringValue = @"Potato Controller";
  }
}

- (void)switchType {
  [self.matrix reloadAllCells];
}

- (void)showStats {
  [self.matrix reloadAllCells];
  if ([[PCPreferencesController sharedInstance] showStats]) {
    if (!_loadTimer) {
      _loadTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateLoadInfo) userInfo:nil repeats:YES];
      [self updateLoadInfo];
    }
  } else {
    if (_loadTimer) {
      [_loadTimer invalidate];
      _loadTimer = nil;
    }
  }
}

#pragma mark AllSwitch

- (void)updateAllSwitch {
//  BOOL allOn = YES;
//  BOOL allOff = YES;
//  struct processor_basic_info info;
//  mach_msg_type_number_t i;
//  for (i = 0; i < nprocessors; i++) {
//    if (quick_info(processors[i], &info) != KERN_SUCCESS) {
//      allOn = NO;
//      break;
//    } else {
//      if (!info.running) {
//        allOn = NO;
//      } else if (!info.is_master) {
//        allOff = NO;
//      }
//    }
//  }
//  if (allOn) {
//    allSwitch.on = YES;
//  } else if (allOff) {
//    allSwitch.on = NO;
//  } else {
//    [allSwitch animateToValue:0.5f];
//  }
}

//- (IBAction)allSwitched:(DZSwitch *)sender {
//  BOOL turnOn = sender.on;
//  struct processor_basic_info info;
//  mach_msg_type_number_t i;
//  for (i = 0; i < nprocessors; i++) {
//    if (quick_info(processors[i], &info) != KERN_SUCCESS) {
//      break;
//    } else {
//      if (info.is_master) {
//        continue;
//      }
//      if (turnOn) {
//        processor_start(processors[i]);
//      } else {
//        processor_exit(processors[i]);
//      }
//    }
//  }
//  [self.matrix reloadAllCells];
//}

@end

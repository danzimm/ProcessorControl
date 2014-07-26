//
//  DZMatrixViewDelegate.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;

@class DZMatrixView;
@protocol DZMatrixViewDelegate <NSObject>

@required
- (void)matrix:(DZMatrixView *)matrix drawLayer:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column;
@optional
- (void)matrix:(DZMatrixView *)matrix mouseDown:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column;
- (void)matrix:(DZMatrixView *)matrix mouseOut:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column;
- (void)matrix:(DZMatrixView *)matrix mouseUp:(CALayer *)cell row:(NSUInteger)row column:(NSUInteger)column;

@end

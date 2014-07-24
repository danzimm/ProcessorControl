//
//  DZMatrixView.h
//  controltest
//
//  Created by Dan Zimmerman on 4/26/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Cocoa;

@protocol DZMatrixViewDelegate;

@interface DZMatrixView : NSView

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns cellSize:(CGSize)size interspace:(CGSize)interspace;

- (BOOL)getRow:(NSUInteger *)row column:(NSUInteger *)col forPoint:(NSPoint)aPoint;
- (BOOL)getRow:(NSUInteger *)row column:(NSUInteger *)col ofCell:(CALayer *)cell;

- (CGSize)realSize;

- (NSArray *)cells;
- (CALayer *)cellForRow:(NSUInteger)row column:(NSUInteger)column;

- (void)reloadCell:(CALayer *)cell;
- (void)reloadAllCells;

@property (nonatomic, weak) IBOutlet id <DZMatrixViewDelegate>delegate;

@property (nonatomic) BOOL addsConstraints;

@property (nonatomic) NSUInteger rows, columns;
@property (nonatomic) CGSize cellSize, interspace;

@property (nonatomic) Class cellClass;

@end

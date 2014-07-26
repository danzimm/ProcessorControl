//
//  DZMatrixView.m
//  controltest
//
//  Created by Dan Zimmerman on 4/26/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZMatrixView.h"
#import "DZMatrixViewDelegate.h"

@implementation DZMatrixView {
  CALayer *holdingLayer;
  NSMutableArray *_cells;
}

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns cellSize:(CGSize)size interspace:(CGSize)interspace {
  CGRect r = [self _preFetchWithRows:rows columns:columns cellSize:size interspace:interspace];
  if ((self = [super initWithFrame:NSRectFromCGRect(r)]) != nil) {
    _rows = rows;
    _columns = columns;
    _cellSize= size;
    _interspace = interspace;
    _addsConstraints = YES;
    _cellClass = [CALayer class];
    _cells = [[NSMutableArray alloc] init];
    self.wantsLayer = YES;
    [self updateFrame];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  _cells = [[NSMutableArray alloc] init];
  _addsConstraints = YES;
  _cellClass = [CALayer class];
}

- (void)viewDidMoveToSuperview {
  [super viewDidMoveToSuperview];
  self.wantsLayer = YES;
  [self updateFrame];
}

- (CGRect)_preFetchWithRows:(NSUInteger)rows columns:(NSUInteger)columns cellSize:(CGSize)size interspace:(CGSize)interspace {
  CGFloat width = columns * (size.width + interspace.width) - interspace.width;
  CGFloat height = rows * (size.height + interspace.height) - interspace.height;
  return CGRectMake(0, 0, width, height);
}

- (CGSize)realSize {
  CGRect r = [self _preFetchWithRows:_rows columns:_columns cellSize:_cellSize interspace:_interspace];
  return r.size;
}

- (void)clearCells {
  [_cells enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
    [obj removeFromSuperlayer];
  }];
  [_cells removeAllObjects];
}

- (void)updateFrame {
  if (self.addsConstraints) {
    CGRect f = [self _preFetchWithRows:self.rows columns:self.columns cellSize:self.cellSize interspace:self.interspace];
    NSLayoutConstraint *widthConst = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:f.size.width];
    NSLayoutConstraint *heightConst = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:f.size.height];
    [self.superview addConstraints:@[widthConst, heightConst]];
  }
  
  [self clearCells];
  
  NSUInteger i, col, row;
  for (i = 0; i < self.rows * self.columns; i++) {
    CALayer *layer = [self.cellClass layer];
    layer.cornerRadius = MIN(self.cellSize.width, self.cellSize.height) / 10.f;
    col = i % self.columns;
    row = i / self.columns;
    layer.frame = CGRectMake(col * (self.cellSize.width + self.interspace.width), row * (self.cellSize.height + self.interspace.height), self.cellSize.width, self.cellSize.height);
    [self.layer addSublayer:layer];
    [_cells addObject:layer];
    if (self.delegate) {
      [self.delegate matrix:self drawLayer:layer row:row column:col];
    }
  }
}

#define RERECTER(upper, lower, t) \
- (void)set ## upper:(t)lower { \
  _ ## lower = lower; \
  [self updateFrame]; \
}

RERECTER(Rows, rows, NSUInteger)
RERECTER(Columns, columns, NSUInteger)
RERECTER(CellSize, cellSize, CGSize)
RERECTER(Interspace, interspace, CGSize)

- (void)setCellClass:(Class)cellClass {
  if ([cellClass isSubclassOfClass:[CALayer class]]) {
    _cellClass = cellClass;
    [self reloadAllCells];
  }
}

- (BOOL)isFlipped {
  return YES;
}

- (BOOL)getRow:(NSUInteger *)row column:(NSUInteger *)col forPoint:(NSPoint)aPoint {
  if (aPoint.x < 0 || aPoint.x > self.frame.size.width || aPoint.y < 0 || aPoint.y > self.frame.size.height) {
    return NO;
  }
  if (col) {
    float fcol = aPoint.x / (self.cellSize.width + self.interspace.width);
    *col = floor(fcol);
  }
  if (row) {
    float frow = aPoint.y / (self.cellSize.height + self.interspace.height);
    *row = floor(frow);
  }
  return YES;
}

- (void)setFrame:(NSRect)frameRect {
  [super setFrame:frameRect];
  [self reloadAllCells];
}

- (BOOL)getRow:(NSUInteger *)row column:(NSUInteger *)col ofCell:(CALayer *)cell {
  CGPoint p = CGPointMake(CGRectGetMidX(cell.frame), CGRectGetMidY(cell.frame));
  return [self getRow:row column:col forPoint:p];
}

- (CALayer *)fetchDirectSubLayer:(NSPoint)p {
  size_t tries = 0;
  p.y = self.frame.size.height - p.y;
  CALayer *gotLayed = [self.layer hitTest:p];
  while (gotLayed.superlayer != self.layer && gotLayed != self.layer && tries < 10) {
    gotLayed = gotLayed.superlayer;
    tries++;
  }
  return gotLayed;
}

- (void)mouseDown:(NSEvent *)theEvent {
  CGPoint p = NSPointToCGPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
  CALayer *gotLayed = [self fetchDirectSubLayer:p];
  holdingLayer = nil;
  if (gotLayed != self.layer) {
    holdingLayer = gotLayed;
    [self holdCell:gotLayed];
  }
}

- (void)mouseDragged:(NSEvent *)theEvent {
  CGPoint p = NSPointToCGPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
  CALayer *gotLayed = [self fetchDirectSubLayer:p];
  if (gotLayed != holdingLayer) {
    [self exitCell:holdingLayer];
    if (gotLayed != self.layer) {
      holdingLayer = gotLayed;
    } else {
      holdingLayer = nil;
    }
    [self holdCell:holdingLayer];
  }
}

- (void)mouseUp:(NSEvent *)theEvent {
  CGPoint p = NSPointToCGPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
  CALayer *gotLayed = [self fetchDirectSubLayer:p];
  if (gotLayed != holdingLayer) {
    [self exitCell:holdingLayer];
    if (gotLayed != self.layer) {
      holdingLayer = gotLayed;
    } else {
      holdingLayer = nil;
    }
    [self holdCell:holdingLayer];
  }
  [self releaseCell:holdingLayer];
  holdingLayer = nil;
}

- (void)exitCell:(CALayer *)cell {
  if (cell && self.delegate && [self.delegate respondsToSelector:@selector(matrix:mouseOut:row:column:)]) {
    NSUInteger row = 0, column = 0;
    [self getRow:&row column:&column ofCell:cell];
    [self.delegate matrix:self mouseOut:cell row:row column:column];
  }
}

- (void)holdCell:(CALayer *)cell {
  if (cell && self.delegate && [self.delegate respondsToSelector:@selector(matrix:mouseDown:row:column:)]) {
    NSUInteger row = 0, column = 0;
    [self getRow:&row column:&column ofCell:cell];
    [self.delegate matrix:self mouseDown:cell row:row column:column];
  }
}

- (void)releaseCell:(CALayer *)cell {
  if (cell && self.delegate && [self.delegate respondsToSelector:@selector(matrix:mouseUp:row:column:)]) {
    NSUInteger row = 0, column = 0;
    [self getRow:&row column:&column ofCell:cell];
    [self.delegate matrix:self mouseUp:cell row:row column:column];
  }
}

- (NSArray *)cells {
  return _cells;
}

- (CALayer *)cellForRow:(NSUInteger)row column:(NSUInteger)column {
  return _cells[row * _columns + column];
}

- (void)reloadCell:(CALayer *)cell {
  if (self.delegate) {
    NSUInteger row = 0, column = 0;
    [self getRow:&row column:&column ofCell:cell];
    [self.delegate matrix:self drawLayer:cell row:row column:column];
  }
}

- (void)reloadAllCells {
  [_cells enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
    [self reloadCell:obj];
  }];
}

@end

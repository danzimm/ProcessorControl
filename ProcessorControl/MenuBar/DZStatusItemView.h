//
//  PCStatusItemView.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/20/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Cocoa;

@protocol DZStatusItemViewDelegate;

@interface DZStatusItemView : NSView

- (instancetype)initWithImage:(NSImage *)image delegate:(__weak id <DZStatusItemViewDelegate>)delegate;

@property (nonatomic) BOOL showing;
@property (nonatomic, strong) NSImage *image;

@property (nonatomic, weak) id <DZStatusItemViewDelegate>delegate;

- (void)swapInversion;

@end

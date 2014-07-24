//
//  PCStatusItemView.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/20/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZStatusItemView.h"
#import "DZStatusItemViewDelegate.h"
#import "NSImage+invert.h"

@implementation DZStatusItemView {
  NSImageView *_imageView;
  NSImage *_invertedImage;
}

- (instancetype)initWithImage:(NSImage *)image delegate:(__weak id<DZStatusItemViewDelegate>)delegate {
  if ((self = [super initWithFrame:NSMakeRect(0, 0, [NSStatusBar systemStatusBar].thickness, [NSStatusBar systemStatusBar].thickness)]) != nil) {
    _imageView = [[NSImageView alloc] initWithFrame:self.bounds];
    self.image = image;
    self.delegate = delegate;
    [self addSubview:_imageView];
  }
  return self;
}

- (void)setImage:(NSImage *)image {
  _image = image;
  _invertedImage = _image.inverted;
  [self updateFrame];
}

- (void)swapInversion {
  NSImage *tmp = _image;
  _image = _invertedImage;
  _invertedImage = tmp;
  [self setNeedsDisplay:YES];
}

- (void)setShowing:(BOOL)showing {
  _showing = showing;
  [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
  self.showing = !_showing;
  if (self.delegate) {
    [self.delegate statusItemView:self showing:_showing];
  }
}

- (void)updateFrame {
  // TODO: need to figure out better way for this!!
  self.frame = NSMakeRect(0, 0, /*MAX(_image.size.width, */[NSStatusBar systemStatusBar].thickness/*)*/, [NSStatusBar systemStatusBar].thickness);
  _imageView.frame = self.bounds;
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
  if (_showing)
    [[NSColor selectedMenuItemColor] setFill];
  else
    [[NSColor clearColor] setFill];
  NSRectFill(dirtyRect);
  _imageView.image = _showing ? _invertedImage : _image;
}

@end

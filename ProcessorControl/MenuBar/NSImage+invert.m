//
//  NSImage+invert.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/20/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "NSImage+invert.h"
@import QuartzCore.QuartzCore;

@implementation NSImage (invert)

- (NSImage *)inverted {
    NSImage *ret = [self copy];
    [ret lockFocus];
    
    CIImage *ciImage = [[CIImage alloc] initWithData:[ret TIFFRepresentation]];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage *output = [filter valueForKey:@"outputImage"];
    [output drawInRect:NSMakeRect(0, 0, ret.size.width, ret.size.height) fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeSourceOver fraction:1.0];
    
    [ret unlockFocus];
    
    return ret;
}

- (NSImage *)imageTintedWithColor:(NSColor *)tint {
  NSImage *image = [self copy];
  if (tint) {
    [image lockFocus];
    [tint set];
    NSRect imageRect = {NSZeroPoint, [image size]};
    NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
    [image unlockFocus];
  }
  return image;
}

@end

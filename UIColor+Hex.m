//
//  UIColor+Hex.m
//  bineditor
//
//  Created by Dan Zimmerman on 12/23/13.
//  Copyright (c) 2013 Dan Zimmerman. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation HColor (Hex)

+ (instancetype)colorWithHex:(NSString *)hex {
  if ([hex characterAtIndex:0] == '#') {
    hex = [hex substringFromIndex:1];
  }
  if (hex.length == 8) {
    hex = [hex lowercaseString];
    @try {
      NSString *rstr = [hex substringWithRange:NSMakeRange(0, 2)];
      NSString *gstr = [hex substringWithRange:NSMakeRange(2, 2)];
      NSString *bstr = [hex substringWithRange:NSMakeRange(4, 2)];
      NSString *astr = [hex substringWithRange:NSMakeRange(6, 2)];
      
      float r,g,b,a;
      r = (float)strtol(rstr.UTF8String, NULL, 16) / 255.f;
      g = (float)strtol(gstr.UTF8String, NULL, 16) / 255.f;
      b = (float)strtol(bstr.UTF8String, NULL, 16) / 255.f;
      a = (float)strtol(astr.UTF8String, NULL, 16) / 255.f;
      
      return [HColor colorWithRed:r green:g blue:b alpha:a];
    }
    @catch (NSException *exception) {
      return nil;
    }
    @finally {
    }
  } else if (hex.length == 6) {
    @try {
      NSString *rstr = [hex substringWithRange:NSMakeRange(0, 2)];
      NSString *gstr = [hex substringWithRange:NSMakeRange(2, 2)];
      NSString *bstr = [hex substringWithRange:NSMakeRange(4, 2)];
      
      float r,g,b;
      r = (float)strtol(rstr.UTF8String, NULL, 16) / 255.f;
      g = (float)strtol(gstr.UTF8String, NULL, 16) / 255.f;
      b = (float)strtol(bstr.UTF8String, NULL, 16) / 255.f;
      
      return [HColor colorWithRed:r green:g blue:b alpha:1.0];
    }
    @catch (NSException *exception) {
      return nil;
    }
    @finally {
    }
  }
}

- (NSString *)hex {
  CGFloat r=0,g=0,b=0,a=0;
  if (CGColorSpaceGetModel(CGColorGetColorSpace([self CGColor])) == 0) {
    [self getWhite:&r alpha:&a];
    g=b=r;
  } else {
#if TARGET_OS_MAC
    [self getRed:&r green:&g blue:&b alpha:&a];
#else
    if (![self getRed:&r green:&g blue:&b alpha:&a])
      return @"00000000";
#endif
  }
  r *= 255;
  g *= 255;
  b *= 255;
  a *= 255;
  
  unsigned char rr, gg, bb, aa;
  rr = 0xff & (char)(floor(r + 0.5));
  gg = 0xff & (char)(floor(g + 0.5));
  bb = 0xff & (char)(floor(b + 0.5));
  aa = 0xff & (char)(floor(a + 0.5));
  NSString *ret = [NSString stringWithFormat:@"%02x%02x%02x%02x", rr,gg,bb,aa];
  return ret;
}

@end

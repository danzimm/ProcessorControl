//
//  DZCheat.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/26/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZCheat.h"

@implementation DZCheat

+ (instancetype)cheatWithCode:(NSString *)cheatCode success:(void (^)(void))success {
  DZCheat *cheat = [[self alloc] init];
  cheat.cheatCode = cheatCode;
  cheat.success = success;
  cheat.callback = ^BOOL(DZKeyHandler *selfk, NSEvent *event) {
    DZCheat *self = (DZCheat *)selfk;
    NSString *characters = event.characters;
    NSString *currentLetter = [self.cheatCode substringWithRange:NSMakeRange(self.index, 1)];
    if ([characters isEqualToString:currentLetter]) {
      self.index++;
      if (self.index == self.cheatCode.length) {
        self.index = 0;
        if (self.success)
          self.success();
      }
      return YES;
    }
    self.index = 0;
    return NO;
  };
  return cheat;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ index=%lu cheatCode=%@", [super description], (unsigned long)self.index, self.cheatCode];
}

@end

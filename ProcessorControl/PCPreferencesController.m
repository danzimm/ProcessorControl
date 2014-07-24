//
//  PCPreferences.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/28/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "PCPreferencesController.h"

@implementation PCPreferencesController
@dynamic potatod, switchType, showStats;

static PCPreferencesController *_sharedInstance = nil;

+ (void)initialize {
  _sharedInstance = [[PCPreferencesController alloc] init];
}

+ (instancetype)sharedInstance {
  return _sharedInstance;
}

- (void)registerDefaults {
  NSDictionary *defaults = @{@"PCShowStats": @(NO)};
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (instancetype)init {
  if ((self = [super init]) != nil) {
    [self registerDefaults];
  }
  return self;
}

#define STRINGY(a) # a

#define GETTER(u, l, t, tt) \
- (t)l { \
  return [[NSUserDefaults standardUserDefaults] tt ## orKey: @("PC"STRINGY(u))]; \
}

#define SETTER(u, t, utt) \
- (void)set ## u: (t)l { \
  [[NSUserDefaults standardUserDefaults] set ## utt:l forKey: @("PC"STRINGY(u))]; \
  [[NSNotificationCenter defaultCenter] postNotificationName: @("PC"STRINGY(u)) object:nil]; \
}

#define OBSERVER(u, l) \
- (void)remove ## u ## Observer:(id)obs { \
  [[NSNotificationCenter defaultCenter] removeObserver:obs name:@("PC"STRINGY(u)) object:nil]; \
} \
- (void)add ## u ## Observer:(id)obs { \
  [[NSNotificationCenter defaultCenter] addObserver:obs selector:@selector(l) name:@("PC"STRINGY(u)) object:nil]; \
}

#define GETSET(u, l, t, tt, utt) \
GETTER(u, l, t, tt) \
SETTER(u, t, utt) \
OBSERVER(u, l)

#define GETSETBOOL(u, l) GETSET(u, l, BOOL, boolF, Bool)
//#define GETSETINTEGER(u, l) GETSET(u, l, NSInteger, integerF, Integer)
#define GETSETTYPEDINTEGER(u, l, t) GETSET(u, l, t, integerF, Integer)

GETSETBOOL(Potatod, potatod)
GETSETTYPEDINTEGER(SwitchType, switchType, PCSwitchType)
GETSETBOOL(ShowStats, showStats)

- (void)removeObserver:(id)obs {
  [self removePotatodObserver:obs];
  [self removeShowStatsObserver:obs];
  [self removeSwitchTypeObserver:obs];
}

@end

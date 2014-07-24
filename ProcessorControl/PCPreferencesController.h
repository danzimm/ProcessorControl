//
//  PCPreferences.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/28/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;

#define OBSERVER(u) \
- (void)add ## u ## Observer:(id)obs; \
- (void)remove ## u ## Observer:(id)obs

#define PREFERENCE(u, l, t) \
@property (nonatomic) t l; \
OBSERVER(u)

typedef NS_ENUM(NSInteger, PCSwitchType) {
  PCSwitchTypeSmiley = -1,
  PCSwitchTypeDefault = 0
};

@interface PCPreferencesController : NSObject

+ (instancetype)sharedInstance;

PREFERENCE(Potatod, potatod, BOOL);
PREFERENCE(SwitchType, switchType, PCSwitchType);
PREFERENCE(ShowStats, showStats, BOOL);

- (void)removeObserver:(id)obs;

@end

#undef PREFERENCE
#undef OBSERVER
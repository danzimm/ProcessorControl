//
//  DZCheat.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/26/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;
#import "DZKeyHandler.h"

@interface DZCheat : DZKeyHandler

+ (instancetype)cheatWithCode:(NSString *)cheatCode success:(void (^)(void))success;

@property (nonatomic, copy) NSString *cheatCode;
@property (nonatomic) NSUInteger index;
@property (nonatomic, copy) void (^success)(void);

@end

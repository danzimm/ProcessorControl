//
//  NSObject+Cascading.m
//  bineditor
//
//  Created by Dan Zimmerman on 2/2/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "NSObject+Cascading.h"

@implementation NSObject (Cascading)

- (instancetype)cascade:(void (^)(id))cb {
    cb(self);
    return self;
}

@end

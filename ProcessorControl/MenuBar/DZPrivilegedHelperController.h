//
//  DZPrivilegedHelperController.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZPrivilegedHelperController : NSObject

+ (NSError *)installHelperWithLabel:(NSString *)label;

@end

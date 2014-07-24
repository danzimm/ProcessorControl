
//
//  DZViewContollerAdditions.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZViewContollerAdditions <NSObject>
@optional
- (void)viewWillShow;
- (void)viewDidShow;
- (void)viewWillHide;
- (void)viewDidHide;

@end

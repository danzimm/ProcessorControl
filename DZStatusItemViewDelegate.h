//
//  DZStatusItemViewDelegate.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;

@class DZStatusItemView;
@protocol DZStatusItemViewDelegate <NSObject>
@required
- (void)statusItemView:(DZStatusItemView *)statusItemView showing:(BOOL)showing;

@end

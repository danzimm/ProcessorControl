//
//  NSObject+Cascading.h
//  bineditor
//
//  Created by Dan Zimmerman on 2/2/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import Foundation;

@interface NSObject (Cascading)

- (instancetype)cascade:(void(^)(id self))cb;

@end

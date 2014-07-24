//
//  NSObject+DelayedBlock.h
//  Sluzzle
//
//  Created by Dan Zimmerman on 4/11/13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (DelayedBlock)

- (void)performBlock:(void (^)(id obj))bl withObject:(id)obj afterDelay:(NSTimeInterval)ti;
- (instancetype)blockAndReturn:(void (^)(id))bl;

@end

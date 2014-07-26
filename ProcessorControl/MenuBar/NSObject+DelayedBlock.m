//
//  NSObject+DelayedBlock.m
//  Sluzzle
//
//  Created by Dan Zimmerman on 4/11/13.
//
//

#import "NSObject+DelayedBlock.h"

@interface NSObjectBlockInternal : NSObject {
    id _object;
    void (^_blockCallback)(id object);
}

- (id)initWithObject:(id)obj block:(void (^)(id obj))bl;
- (void)call;

@end

@implementation NSObjectBlockInternal

- (id)initWithObject:(id)obj block:(void (^)(id))bl {
    if ((self = [super init]) != nil) {
        _object = obj;
#if !__has_feature(objc_arc)
        _blockCallback = Block_copy(bl);
#else
        _blockCallback = bl;
#endif
    }
    return self;
}

- (void)call {
    _blockCallback(_object);
    
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    Block_release(_blockCallback);
    [super dealloc];
}
#endif

@end

@implementation NSObject (DelayedBlock)

- (void)performBlock:(void (^)(id obj))bl withObject:(id)obj afterDelay:(NSTimeInterval)ti {
    NSObjectBlockInternal *blInt = [[NSObjectBlockInternal alloc] initWithObject:obj block:bl];
    [self performSelector:@selector(_internalBlockSelector:) withObject:blInt afterDelay:ti]; //gah its not a leak look below!
}

- (void)_internalBlockSelector:(NSObjectBlockInternal *)blInt {
    [blInt call];
#if !__has_feature(objc_arc)
    [blInt release];
#endif
}

- (instancetype)blockAndReturn:(void (^)(id))bl {
    bl(self);
    return self;
}

@end

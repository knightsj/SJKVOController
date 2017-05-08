//
//  SJKVOObserverInfo.m
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import "SJKVOObserverItem.h"

@implementation SJKVOObserverItem

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key setterSelector:(SEL)setterSelector setterMethod:(Method)setterMethod block:(SJKVOBlock)block

{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _setterSelector = setterSelector;
        _setterMethod = setterMethod;
        _block = block;
    }
    return self;
}

- (instancetype)init{
    
    NSAssert(NO, @"SJKVOLog:must use ‘initWithObserver:key:setterSelector:setterMethod:block:’ initializer");
    return nil;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"SJKVOLog:observer item:{observer: %@ | key: %@ | setter: %@}",_observer,_key,NSStringFromSelector(_setterSelector)];
}
@end

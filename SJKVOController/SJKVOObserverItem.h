//
//  SJKVOObserverInfo.h
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void(^SJKVOBlock)(id observedObject, NSString *key, id oldValue, id newValue);

@interface SJKVOObserverItem : NSObject

@property (nonatomic, strong) NSObject *observer;
@property (nonatomic, copy)   NSString *key;
@property (nonatomic, assign) SEL setterSelector;
@property (nonatomic, assign) Method setterMethod;
@property (nonatomic, copy)   SJKVOBlock block;


- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key setterSelector:(SEL)setterSelector setterMethod:(Method)setterMethod block:(SJKVOBlock)block;

@end

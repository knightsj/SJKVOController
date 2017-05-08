//
//  NSObject+SJKVOController.h
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJKVOHeader.h"

@interface NSObject (SJKVOController)


//============== add observer ===============//

- (void)sj_addObserver:(NSObject *)observer forKeys:(NSArray <NSString *>*)keys withBlock:(SJKVOBlock)block;
- (void)sj_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(SJKVOBlock)block;


//============= remove observer =============//

- (void)sj_removeObserver:(NSObject *)observer forKeys:(NSArray <NSString *>*)keys;
- (void)sj_removeObserver:(NSObject *)observer forKey:(NSString *)key;
- (void)sj_removeObserver:(NSObject *)observer;
- (void)sj_removeAllObservers;


//============= list observers ===============//

- (void)sj_listAllObservers;

@end

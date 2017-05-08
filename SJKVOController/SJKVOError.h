//
//  SJKVOError.h
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    SJKVOErrorTypeNoObervingObject,
    SJKVOErrorTypeNoObervingKey,
    SJKVOErrorTypeNoObserverOfObject,
    SJKVOErrorTypeNoMatchingSetterForKey,
    SJKVOErrorTypeTransferSetterToGetterFailded,
    SJKVOErrorTypeInvalidInputObservingKeys,
    
} SJKVOErrorTypes;

@interface SJKVOError : NSError

+ (id)errorNoObervingObject;
+ (id)errorNoObervingKey;
+ (id)errorNoMatchingSetterForKey:(NSString *)key;
+ (id)errorTransferSetterToGetterFaildedWithSetterName:(NSString *)setterName;
+ (id)errorNoObserverOfObject:(id)object;
+ (id)errorInvalidInputObservingKeys;

@end

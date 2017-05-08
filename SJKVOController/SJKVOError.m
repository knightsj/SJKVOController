//
//  SJKVOError.m
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import "SJKVOError.h"

NSString* const SJKVOErrorDomain = @"SJKVOErrorDomain";

@implementation SJKVOError

+ (id)errorNoObervingObject
{
    NSString *message = [NSString stringWithFormat:@"SJKVOError:There is no Observing Object"];
    return [NSError errorWithDomain:SJKVOErrorDomain code:SJKVOErrorTypeNoObervingObject userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorNoObervingKey
{
    NSString *message = [NSString stringWithFormat:@"SJKVOError:There is no Observing Key"];
    return [NSError errorWithDomain:SJKVOErrorDomain code:SJKVOErrorTypeNoObervingKey userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorNoObserverOfObject:(id)object
{
    NSString *message = [NSString stringWithFormat:@"SJKVOError:There is no observer Of Object:%@",object];
    return [NSError errorWithDomain:SJKVOErrorDomain code:SJKVOErrorTypeNoObserverOfObject userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorNoMatchingSetterForKey:(NSString *)key
{
    NSString *message = [NSString stringWithFormat:@"SJKVOError:There is no matching setter for key:%@",key];
    return [NSError errorWithDomain:SJKVOErrorDomain code:SJKVOErrorTypeNoMatchingSetterForKey userInfo:@{NSLocalizedDescriptionKey:message}];
}

+ (id)errorTransferSetterToGetterFaildedWithSetterName:(NSString *)setterName
{
    NSString *message = [NSString stringWithFormat:@"SJKVOError:TransferSetterToGetterFaildedWithSetterName:%@",setterName];
    return [NSError errorWithDomain:SJKVOErrorDomain code:SJKVOErrorTypeTransferSetterToGetterFailded userInfo:@{NSLocalizedDescriptionKey:message}];
}


+ (id)errorInvalidInputObservingKeys
{
    NSString *message = [NSString stringWithFormat:@"SJKVOError:Invalid input observing keys"];
    return [NSError errorWithDomain:SJKVOErrorDomain code:SJKVOErrorTypeInvalidInputObservingKeys userInfo:@{NSLocalizedDescriptionKey:message}];
}
@end

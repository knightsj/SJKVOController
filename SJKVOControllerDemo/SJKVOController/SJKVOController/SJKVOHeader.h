//
//  SJKVOHeader.h
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/5.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#ifndef SJKVOHeader_h
#define SJKVOHeader_h

#import <objc/runtime.h>
#import <objc/message.h>


#import "SJKVOObserverItem.h"
#import "SJKVOTool.h"
#import "SJKVOError.h"



#define SJFunc SJLog(@"%s",__func__);

#ifdef DEBUG

#define SJLog(...) NSLog(__VA_ARGS__)

#else

#define SJLog(...)

#endif



#endif /* SJKVOHeader_h */

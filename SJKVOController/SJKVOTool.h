//
//  SJKVOTool.h
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface SJKVOTool : NSObject

//setter <-> getter
+ (NSString *)getterFromSetter:(NSString *)setter;
+ (NSString *)setterFromGetter:(NSString *)getter;

//get method from a class by a specific selector
+ (Method)objc_methodFromClass:(Class)cls selector:(SEL)selector;

//check a class has a specific selector or not
+ (BOOL)detectClass:(Class)cls hasSelector:(SEL)selector;

@end

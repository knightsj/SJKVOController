//
//  SJKVOTool.m
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import "SJKVOTool.h"

@implementation SJKVOTool


+ (NSString *)getterFromSetter:(NSString *)setter
{
    
    if ( (setter.length <= 0) || (![setter hasPrefix:@"set"]) || (![setter hasSuffix:@":"]) ) {
        return nil;
    }
    
    // remove 'set' and ':'
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *getter = [setter substringWithRange:range];
    
    // lowercase the first letter
    NSString *firstLetter = [[getter substringToIndex:1] lowercaseString];
    getter = [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    return getter;
}


+ (NSString *)setterFromGetter:(NSString *)getter
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingPart = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingPart];
    
    return setter;
}

+ (Method)objc_methodFromClass:(Class)cls selector:(SEL)selector
{
    return class_getInstanceMethod(cls, selector);
}


+ (BOOL)detectClass:(Class)cls hasSelector:(SEL)selector
{
    BOOL hasSelector = NO;
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(cls, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        
        SEL tmpSelector = method_getName(methodList[i]);
        if (tmpSelector == selector) {
            free(methodList);
            hasSelector = YES;
        }
    }
    if (!hasSelector) {
        free(methodList);
    }
    
    return hasSelector;
}


@end

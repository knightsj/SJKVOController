//
//  NSObject+SJKVOController.m
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import "NSObject+SJKVOController.h"

//get current class:maybe none-kvo class, maybe KVO class(when already has been observed)
#define OriginalClass object_getClass(self)

//fixed prefix of kVO Class
NSString *const SJKVOClassPrefix = @"SJKVOClass_";

//keypath to hold associated set of observers
static const char SJKVOObservers;



@implementation NSObject (SJKVOController)

#pragma mark- Public APIs

- (void)sj_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(SJKVOBlock)block
{
    //error: no observer
    if (!observer) {
        SJLog(@"%@",[SJKVOError errorNoObervingObject]);
        return;
    }
    
    //error: no specific key
    if (key.length == 0) {
        SJLog(@"%@",[SJKVOError errorNoObervingKey]);
    }
    
    //check: if specific setter exists
    SEL setterSelector = NSSelectorFromString([SJKVOTool setterFromGetter:key]);
    Method setterMethod = [SJKVOTool objc_methodFromClass:[self class] selector:setterSelector];
    
    //error: no specific setter mothod
    if (!setterMethod) {
        SJLog(@"%@",[SJKVOError errorNoMatchingSetterForKey:key]);
        return;
    }
    
    //get original class(current class,may be KVO class)
    NSString *originalClassName = NSStringFromClass(OriginalClass);
    
    if ([originalClassName hasPrefix:SJKVOClassPrefix]) {
        //now,the OriginalClass is KVO class, we should destroy it and make new one
        Class CurrentKVOClass = OriginalClass;
        object_setClass(self, class_getSuperclass(OriginalClass));
        objc_disposeClassPair(CurrentKVOClass);
        originalClassName = [originalClassName substringFromIndex:(SJKVOClassPrefix.length)];
    }
    
    //create a KVO class
    Class KVOClass = [self createKVOClassFromOriginalClassName:originalClassName];
    
    //swizzle isa from self to KVO class
    object_setClass(self, KVOClass);
    
    //if we already have some history observer items, we should add them into new KVO class
    NSMutableSet* observers = objc_getAssociatedObject(self, &SJKVOObservers);
    if (observers.count > 0) {
        
        NSMutableSet *newObservers = [[NSMutableSet alloc] initWithCapacity:5];
        objc_setAssociatedObject(self, &SJKVOObservers, newObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (observers.count>0) {
            for (SJKVOObserverItem *item in observers) {
                [self KVOConfigurationWithObserver:item.observer key:item.key block:item.block kvoClass:KVOClass setterSelector:item.setterSelector setterMethod:setterMethod];
            }
        }
    }
    
    //ignore same observer and key:if the observer and key are same with saved observerItem,we should not add them one more time
    BOOL findSameObserverAndKey = NO;
    if (observers.count>0) {
        for (SJKVOObserverItem *item in observers) {
            if ( (item.observer == observer) && [item.key isEqualToString:key]) {
                findSameObserverAndKey = YES;
            }
        }
    }
    
    if (!findSameObserverAndKey) {
        [self KVOConfigurationWithObserver:observer key:key block:block kvoClass:KVOClass setterSelector:setterSelector setterMethod:setterMethod];
    }
    
    
}

- (void)KVOConfigurationWithObserver:(NSObject *)observer key:(NSString *)key block:(SJKVOBlock)block kvoClass:(Class)kvoClass setterSelector:(SEL)setterSelector setterMethod:(Method)setterMethod
{
    //add setter method in KVO Class
    if(![SJKVOTool detectClass:OriginalClass hasSelector:setterSelector]){
        class_addMethod(kvoClass, setterSelector, (IMP)kvo_setter_implementation, method_getTypeEncoding(setterMethod));
    }
    
    //add item of this observer&&key pair
    [self addObserverItem:observer key:key setterSelector:setterSelector setterMethod:setterMethod block:block];
}

- (void)sj_addObserver:(NSObject *)observer
               forKeys:(NSArray <NSString *>*)keys
             withBlock:(SJKVOBlock)block
{
    //error: keys array is nil or no elements
    if (keys.count == 0) {
        SJLog(@"%@",[SJKVOError errorInvalidInputObservingKeys]);
        return;
    }
    
    //one key corresponding to one specific item, not the observer
    [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sj_addObserver:observer forKey:key withBlock:block];
    }];
}

- (void)sj_removeObserver:(NSObject *)observer
                  forKeys:(NSArray <NSString *>*)keys
{
    NSMutableSet *observers = objc_getAssociatedObject(self, &SJKVOObservers);
    NSMutableSet *removingItems = [[NSMutableSet alloc] initWithCapacity:5];
    
    if (observers.count > 0 && keys.count > 0) {
        
        for (SJKVOObserverItem* item in observers) {
            if (item.observer == observer){
                for (NSString *key in keys) {
                    if ([item.key isEqualToString:key]) {
                        [removingItems addObject:item];
                    }
                }
            }
        }
        
        if (removingItems.count > 0) {
            
            [removingItems enumerateObjectsUsingBlock:^(SJKVOObserverItem* item, BOOL * _Nonnull stop) {
                [observers removeObject:item];
            }];
        }
    }
}

- (void)sj_removeObserver:(NSObject *)observer
                   forKey:(NSString *)key
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &SJKVOObservers);
    
    if (observers.count > 0) {
        
        SJKVOObserverItem *removingItem = nil;
        for (SJKVOObserverItem* item in observers) {
            if (item.observer == observer && [item.key isEqualToString:key]) {
                removingItem = item;
                break;
            }
        }
        if (removingItem) {
            [observers removeObject:removingItem];
        }
        
    }
}


- (void)sj_removeObserver:(NSObject *)observer
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &SJKVOObservers);
    NSMutableSet* removingItems = [[NSMutableSet alloc] initWithCapacity:5];
    
    if (observers.count > 0) {
        
        [observers enumerateObjectsUsingBlock:^(SJKVOObserverItem* item, BOOL * _Nonnull stop) {
            if (item.observer == observer) {
                [removingItems addObject:item];
            }
        }];
        
        if (removingItems.count > 0) {
            
            [removingItems enumerateObjectsUsingBlock:^(SJKVOObserverItem* item, BOOL * _Nonnull stop) {
                [observers removeObject:item];
            }];
            
        }
    }
}


- (void)sj_removeAllObservers
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &SJKVOObservers);
    
    if (observers.count > 0) {
        [observers removeAllObjects];
        SJLog(@"SJKVOLog:Removed all obserbing objects of object:%@",self);
        
    }else{
        SJLog(@"SJKVOLog:There is no observers obserbing object:%@",self);
    }
}

- (void)sj_listAllObservers
{
    NSMutableSet* observers = objc_getAssociatedObject(self, &SJKVOObservers);
    
    if (observers.count == 0) {
        SJLog(@"SJKVOLog:There is no observers obserbing object:%@",self);
        return;
    }
    
    
    SJLog(@"SJKVOLog:==================== Start Listing All Observers: ====================");
    for (SJKVOObserverItem* item in observers) {
        SJLog(@"%@",item);
    }
}

#pragma mark- Private methods

- (void)addObserverItem:(NSObject *)observer
                    key:(NSString *)key
         setterSelector:(SEL)setterSelector
           setterMethod:(Method)setterMethod
                  block:(SJKVOBlock)block
{
    
    NSMutableSet *observers = objc_getAssociatedObject(self, &SJKVOObservers);
    if (!observers) {
        observers = [[NSMutableSet alloc] initWithCapacity:10];
        objc_setAssociatedObject(self, &SJKVOObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    SJKVOObserverItem *item = [[SJKVOObserverItem alloc] initWithObserver:observer Key:key setterSelector:setterSelector setterMethod:setterMethod block:block];
    
    if (item) {
        [observers addObject:item];
    }
    
}

- (Class)createKVOClassFromOriginalClassName:(NSString *)originalClassName
{
    NSString *kvoClassName = [SJKVOClassPrefix stringByAppendingString:originalClassName];
    Class KVOClass = NSClassFromString(kvoClassName);
    
    // KVO class already exists
    if (KVOClass) {
        return KVOClass;
    }
    
    // if there is no KVO class, then create one
    KVOClass = objc_allocateClassPair(OriginalClass, kvoClassName.UTF8String, 0);//OriginalClass is super class
    
    // pretending to be the original class:return the super class in class method
    Method clazzMethod = class_getInstanceMethod(OriginalClass, @selector(class));
    class_addMethod(KVOClass, @selector(class), (IMP)return_original_class, method_getTypeEncoding(clazzMethod));
    
    // finally, register this new KVO class
    objc_registerClassPair(KVOClass);
    
    return KVOClass;
}

//implementation of KVO setter method
void kvo_setter_implementation(id self, SEL _cmd, id newValue)
{
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [SJKVOTool getterFromSetter:setterName];
    

    if (!getterName) {
        SJLog(@"%@",[SJKVOError errorTransferSetterToGetterFaildedWithSetterName:setterName]);
        return;
    }
    
    // create a super class of a specific instance
    Class superclass = class_getSuperclass(OriginalClass);
    
    struct objc_super superclass_to_call = {
        .super_class = superclass,  //super class
        .receiver = self,           //insatance of this class
    };
    
    // cast method pointer
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, the supper is the original class
    objc_msgSendSuperCasted(&superclass_to_call, _cmd, newValue);
    
    // look up observers and call the blocks
    NSMutableSet *observers = objc_getAssociatedObject(self,&SJKVOObservers);
    
    if (observers.count <= 0) {
        SJLog(@"%@",[SJKVOError errorNoObserverOfObject:self]);
        return;
    }
    
    //get the old value
    id oldValue = [self valueForKey:getterName];
    
    for (SJKVOObserverItem *item in observers) {
        if ([item.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //call block
                item.block(self, getterName, oldValue, newValue);
            });
        }
    }
}


Class return_original_class(id self, SEL _cmd)
{
    return class_getSuperclass(OriginalClass);//because the original class is the super class of KVO class
}


@end

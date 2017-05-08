## SJKVOController
A KVO implementation by using block, which is inspired by [ImplementKVO](https://github.com/okcomp/ImplementKVO).

## How to use:

1. Move SJKVOController folder in your project.
2. ``#import "NSObject+SJKVOController.h"``
3. add observer and key or keys :

#### add together:
```objc
[self.model sj_addObserver:self forKeys:keys withBlock:^(id observedObject, NSString *key, id oldValue, id newValue) {
        
        if ([key isEqualToString:@"number"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.numberLabel.text = [NSString stringWithFormat:@"%@",newValue];
            });
            
        }else if ([key isEqualToString:@"color"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.numberLabel.backgroundColor = newValue;
            });
        }
        
    }];
```

#### add separately:

```objc
[self.model sj_addObserver:self forKey:@"number" withBlock:^(id observedObject, NSString *key, id oldValue, id newValue) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.numberLabel.text = [NSString stringWithFormat:@"%@",newValue];
        });
        
}];
    
    
[self.model sj_addObserver:self forKey:@"color" withBlock:^(id observedObject, NSString *key, id oldValue, id newValue) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.numberLabel.backgroundColor = newValue;
        });
        
}];
```

#### Remove observer and keys:

```objc
- (IBAction)removeAllObservingItems:(UIButton *)sender {
    
    [self.model sj_removeObserver:self forKeys:@[@"number",@"color"]];
//    [self.model sj_removeObserver:self forKeys:@[@"number"]];
//    [self.model sj_removeObserver:self forKey:@"number"];
//    [self.model sj_removeObserver:self];
//    [self.model sj_removeAllObservers];
    
}
```

After removing observers, if there is no observer which is observing this object's property, we'll get output like this:

```objc
SJKVOController[80499:4242749] SJKVOLog:There is no observers obserbing object:<Model: 0x60000003b700>
```

#### List all observers and keys

```objc
- (IBAction)showAllObservingItems:(UIButton *)sender {
    
    [self.model sj_listAllObservers];
}
```

output:

```objc
SJKVOController[80499:4242749] SJKVOLog:==================== Start Listing All Observers: ==================== 
SJKVOController[80499:4242749] SJKVOLog:observer item:{observer: <ViewController: 0x7fa1577054f0> | key: color | setter: setColor:}
SJKVOController[80499:4242749] SJKVOLog:observer item:{observer: <ViewController: 0x7fa1577054f0> | key: number | setter: setNumber:}
```

## Demo presentation:
![](http://oih3a9o4n.bkt.clouddn.com/SJKVOController.gif)

## Code presentation:

#### Use SJKVOController to implement KVO:
```objc
//SJKVOController.h
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
```

#### Use SJKVOObserverItem to record observer item infos:

```objc
//SJKVOObserverItem.h
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
```
#### Use SJKVOError to handle errors:

```objc
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
```

## License
All source code is licensed under the [MIT License](https://github.com/knightsj/SJKVOController/blob/master/LICENSE).


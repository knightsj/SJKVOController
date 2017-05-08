//
//  ViewController.m
//  SJKVOController
//
//  Created by Sun Shijie on 2017/5/4.
//  Copyright © 2017年 Shijie. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "NSObject+SJKVOController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) Model *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.model = [[Model alloc] init];
}

- (IBAction)updateNumber:(UIButton *)sender {
    
    //trigger KVO : number
    NSInteger newNumber = arc4random() % 100;
    self.model.number = [NSNumber numberWithInteger:newNumber];
    
    //trigger KVO : color
    NSArray *colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor]];
    NSInteger colorIndex = arc4random() % 3;
    self.model.color = colors[colorIndex];
}

- (IBAction)addObserverSeparatedly:(UIButton *)sender {
    
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
    
}

- (IBAction)addObserversTogether:(UIButton *)sender {
    
    NSArray *keys = @[@"number",@"color"];
    
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
}


- (IBAction)removeAllObservingItems:(UIButton *)sender {
    
    [self.model sj_removeObserver:self forKeys:@[@"number",@"color"]];
//    [self.model sj_removeObserver:self forKeys:@[@"number"]];
//    [self.model sj_removeObserver:self forKey:@"number"];
//    [self.model sj_removeObserver:self];
//    [self.model sj_removeAllObservers];
    
}


- (IBAction)showAllObservingItems:(UIButton *)sender {
    
    [self.model sj_listAllObservers];
}



@end

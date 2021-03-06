//
//  BSKVOTestController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/17.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSKVOTestController.h"
#import "BSNotifacation.h"
#import "BSObjcPerson.h"
#import <UIView+BSView.h>


@interface BSKVOTestController ()
@property (nonatomic ,strong) BSObjcPerson *person;

@property (nonatomic ,strong) NSString *kk;

@end


@implementation BSKVOTestController

- (void)dealloc
{
    NSLog(@"BSStudyObjcController dealloc");
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBtn];
    [self addObserver];// 自定义notifacation
}


-(void)addBtn{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 84, self.view.width - 40, 40)];
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 300, 40)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(changePersonName) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击触发自定义kvo" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}


-(void)addObserver{
    
    BSObjcPerson *person1 = [[BSObjcPerson alloc]init];
    self.person = person1;
//
//    [BSNotifacation BSNotifacationAddObsever:self object:person1 keyForSel:@selector(name) callBack:^(id  _Nonnull oldValue, id  _Nonnull newValue) {
//        NSLog(@"\nnoti person1:\noldValue = %@\nnewValue = %@",oldValue,newValue);
//    }];
//
//    [person1 addObserver:self forKeyPath:@"reName" options:NSKeyValueObservingOptionNew context:nil];
    
    /// 想触发KVO 需要通过 KVC 设置 _reName 的值，
    /// 并且 KVC 的 key = _reName ，不能是 reName
    [person1 addObserver:self forKeyPath:@"_reName" options:NSKeyValueObservingOptionNew context:nil];
    
    /// 无法通过 _kk = @"12"; 触发KVO
    [self addObserver:self forKeyPath:@"_kk" options:NSKeyValueObservingOptionNew context:nil];

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"observeValueForKeyPath == %@",keyPath);
    
    if ([keyPath isEqualToString:@"reName"]) {
        NSLog(@"reName : %@",self.person.reName);
    }
    
    if ([keyPath isEqualToString:@"_reName"]) {
        NSLog(@"_reName : %@",self.person.reName);
    }
}


#pragma mark - action 交互事件

-(void)changePersonName{
    self.person.name = @"kvo change";
    self.person.age = 20;
    
//    self.person.reName = @"111";
//    [self.person setValue:@"222" forKeyPath:@"reName"];
    [self.person setValue:@"333" forKeyPath:@"_reName"];

    _kk = @"kk";//不同于 KVC 中 设置 _kk 的 value
}



@end

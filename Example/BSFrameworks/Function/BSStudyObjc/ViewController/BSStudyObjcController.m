//
//  BSStudyObjcController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/19.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSStudyObjcController.h"
#import "BSObjcPerson.h"
#import "BSNotifacation.h"
#import <UIView+BSView.h>

#import <objc/objc.h>
#import <objc/runtime.h>

@interface BSStudyObjcController ()

@property (nonatomic ,strong) BSObjcPerson *person;

@end

@implementation BSStudyObjcController

- (void)dealloc
{
    NSLog(@"BSStudyObjcController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(changePersonName) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    BSObjcPerson *person1 = [[BSObjcPerson alloc]init];
    self.person = person1;
    
    [BSNotifacation BSNotifacationAddObsever:self object:person1 keyForSel:@selector(name) callBack:^(id  _Nonnull oldValue, id  _Nonnull newValue) {
         NSLog(@"\nnoti person1:\noldValue = %@\nnewValue = %@",oldValue,newValue);
    }];

//    person1.name = @"personName1";


//    [BSNotifacation BSNotifacationAddObsever:self object:person1 keyForSel:@selector(age) callBack:^(id oldValue, id newValue) {
//        NSLog(@"\nnoti person2:\noldValue = %@\nnewValue = %@",oldValue,newValue);
//
//    }];
//
//    person1.age = 2;
//
//    [BSNotifacation BSNotifacationAddObsever:self object:person1 keyForSel:@selector(age) callBack:^(id oldValue, id newValue) {
//        NSLog(@"\nnoti person3:\noldValue = %@\nnewValue = %@",oldValue,newValue);
//
//    }];
//
//    person1.age = 6;
//    NSString *age = [person1 valueForKey:@"age"];
//    NSLog(@"age ======= %@ == %@",age,person1) ;
    
}

-(void)changePersonName{
    
    self.person.name = @"kvo change";
    self.person.age = 20;
}

@end

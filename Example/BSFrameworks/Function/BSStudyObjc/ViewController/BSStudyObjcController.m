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
#import "BSButton.h"
#import <UIView+BSView.h>

#import <objc/objc.h>
#import <objc/runtime.h>

@interface BSStudyObjcController ()

@property (nonatomic ,strong) BSObjcPerson *person;
@property (nonatomic ,strong) NSThread *thread;

@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger timerCount;


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
    [self addBtn];
    [self addObserver];// 自定义notifacation
//    [self runLoopTest];// runloop 测试
//    [self timerTest]; //timer 测试
}


-(void)timerTest{
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
//        self.timer.tolerance = 2;
//        [self.timer fire];
//        [[NSRunLoop currentRunLoop]run];
//    });
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}


-(void)timerAction{
    NSLog(@"timer 执行");
}



-(void)addBtn{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 84, self.view.width - 40, 40)];
    [self.view addSubview:label];
    
    BSButton *btn = [[BSButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(changePersonName) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}


-(void)addObserver{
    
    BSObjcPerson *person1 = [[BSObjcPerson alloc]init];
    self.person = person1;
    
    [BSNotifacation BSNotifacationAddObsever:self object:person1 keyForSel:@selector(name) callBack:^(id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"\nnoti person1:\noldValue = %@\nnewValue = %@",oldValue,newValue);
    }];
}

-(void)runLoopTest{
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadAction) object:nil];
    [self.thread start];
}

-(void)threadAction{

    NSLog(@" thread start");
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
//        NSLog(@"%f",CFRunLoopGetNextTimerFireDate(CFRunLoopGetCurrent(),CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent())));
      
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"runloop 进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"将处理 timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"将处理 source");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"将进入等待状态，即runloop休息");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"将进入唤醒状态，即runloop要工作了");
                break;
            case kCFRunLoopExit:
                NSLog(@"runloop 退出");
                break;
                
            default:
                break;
        }
        
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
    
    [[NSRunLoop currentRunLoop]addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop]run];
    
    NSLog(@" thread end");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 利用performSelector，在self.thread的线程中调用run2方法执行任务
    [self performSelector:@selector(run2) onThread:self.thread withObject:nil waitUntilDone:NO];
}


- (void)run2{
    
    NSLog(@"----run2 in thread %@-----",[NSThread currentThread]);
}


#pragma mark - action 交互事件

-(void)changePersonName{
    
    self.person.name = @"kvo change";
    self.person.age = 20;
}


@end

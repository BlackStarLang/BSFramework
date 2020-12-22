//
//  BSStudyObjcController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/19.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSStudyObjcController.h"
#import <UIView+BSView.h>

#import <objc/objc.h>
#import <objc/runtime.h>

@interface BSStudyObjcController ()

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

    [self initView];
    [self runLoopTest];// runloop 测试
}

-(void)initView{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT)];
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = 1;
    label.text = @"点击屏幕任意位置，将触发 runloop 监听";
    [self.view addSubview:label];
}


#pragma mark 开启 runloop 测试

-(void)runLoopTest{
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadAction) object:nil];
    [self.thread start];
}

-(void)threadAction{

    NSLog(@"thread start，开始监听 runloop 状态");
    
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


@end

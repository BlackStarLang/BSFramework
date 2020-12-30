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

@property (nonatomic ,strong) dispatch_queue_t queue;


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
    
    /// 以下方法只能开启一个进行测试
//    [self runLoopTest];// runloop 测试
    [self testAsyncSerialQueue];// runloop + GCD_Async + 串行队列测试
    
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



-(void)testAsyncSerialQueue{
    // 查看堆栈可发现
    // 如果不使用 NSThread，而是使用 GCD ，在 runInThread 方法里 调用
    // dispatch_async(self.queue, ^{})，回调将不会执行
    // 猜测原因：首先分析主队列，dispatch_async(dispatch_get_main_queue(),^{})
    // 方法在执行任务的时候，回到了主线程和主队列，可见主队列没有创建子线程的能力。
    // 也就是主线程和主队列是一一对应的关系，测试非主线程串行队列会发现，串行队列最多只有一个线程，
    // 所以综合可以肯定，串行队列只能有一个线程。而在串行队列中，主队列可以使用
    // dispatch_async(dispatch_get_main_queue(),^{})方式可以回到当前线程
    // 在分析非主线程串行队列，在使用 dispatch_async 的时候，会创建一个
    // 如果是并发队列，async 将创建新的子线程，将不会受 threadAction 方法里的 runloop 影响。
    
    
    // 这个例子是为了验证 dispatch_async(dispatch_get_main_queue(),^{}) 的逻辑，
    // 首先dispatch_get_main_queue是串行队列 ，在使用 dispatch_async(dispatch_get_main_queue(),^{})
    // 的时候发现 此函数任务将会在主线程主队列执行，并且将受 main runloop 影响。
    // 故仿照此情况，模拟一个非主队列的异步串行队列。
    // 结果表明，串行队列下，只有主队列执行的 dispatch_async(dispatch_get_main_queue(),^{})函数可以调用，
    // 而非主队列的异步操作，如果异步操作在为当前的非主队列里，那么将不会执行
    
    self.queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(self.queue, ^{
        self.thread = [NSThread currentThread];
        [self threadAction];
    });
}


-(void)threadAction{

    NSLog(@"thread start，开始监听 runloop 状态");
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
//        NSLog(@"%f",CFRunLoopGetNextTimerFireDate(CFRunLoopGetCurrent(),CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent())));
        NSLog(@"\n");
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
    
    NSLog(@" runloop 结束");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 利用performSelector，在self.thread的线程中调用runInThread方法执行任务
    [self performSelector:@selector(runInThread) onThread:self.thread withObject:nil waitUntilDone:NO];
}


- (void)runInThread{
    
    dispatch_async(self.queue, ^{
        NSLog(@"haha");
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
    
    NSLog(@"RunInThread in thread %@",[NSThread currentThread]);
}


@end

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
@property (nonatomic ,strong) dispatch_queue_t queue;

@property (nonatomic ,assign) CFRunLoopObserverRef observer;
@property (nonatomic ,assign) BOOL stop;

@end

@implementation BSStudyObjcController

- (void)dealloc
{

    NSLog(@"BSStudyObjcController dealloc");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _stop = YES;
    [self performSelector:@selector(runInThread) onThread:self.thread withObject:nil waitUntilDone:NO];
//    CFRunLoopStop(CFRunLoopGetCurrent());
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
    
    // 如果不使用 NSThread，而是使用 GCD ，在 runInThread 方法里 调用
    // dispatch_async(self.queue, ^{})，回调将不会执行，原因未知
    
    // 这个例子是为了验证 dispatch_async(dispatch_get_main_queue(),^{}) 的逻辑，
    // 首先dispatch_get_main_queue是串行队列 ，在使用
    // dispatch_async(dispatch_get_main_queue(),^{})的时候，
    // 任务将会在主线程主队列下执行，并且将受 main runloop 影响（查看堆栈可以看出）。
    // 故仿照此情况，模拟一个非主队列的异步串行队列。
    // 结果表明，串行队列下，只有主队列执行的 dispatch_async(dispatch_get_main_queue(),^{})函数可以调用，
    // 而非主队列的异步操作，将不会执行（启动runloop的前提下）
    
    self.queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(self.queue, ^{
        self.thread = [NSThread currentThread];
        [self threadAction];
    });
}


/// 时隔数日，追加研究，搞清了为什么 模仿的主线程、主队列、主runloop下
/// dispatch_async 不执行的问题
///
/// - (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;
/// 此方法用来处理输入源的时候与 run 方法有很大区别，此方法只会处理一次输入源，或者
/// 到达 limitDate ，就会退出
/// 此案例使用while循环解决他一次就退出的问题，使用stop来解决什么时候退出（dealloc）
/// 这样就解决了内存泄漏的问题
/// 当 runloop 退出后，在self.queue中执行的异步任务才会执行。
/// 个人理解：因为runloop卡着线程，然后使用异步任务，会将此任务放于 runloop 后，
/// 然后 dispatch_async 执行的任务会一直等待runloop结束，所以就出现了开启runloop
/// 使用 dispatch_async（queue）不会执行任务的问题。
/// 但是主线程主队列和主runloop为什么可以，这个还不太明白
///

-(void)threadAction{

    NSLog(@"thread start，开始监听 runloop 状态");
    
    self.observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
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
    
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observer, kCFRunLoopDefaultMode);
    CFRelease(self.observer);
    [[NSRunLoop currentRunLoop]addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    /// 此 while 循环，首先 runloop 是会卡线程的（因为串行队列），
    /// 所以 while 循环需要等到 runloop 退出后才执行下一次，不会出现一直调用
    /// runMode 的情况。
    ///
    /// [[NSRunLoop currentRunLoop]run] 和
    /// [[NSRunLoop currentRunLoop]runUntilDate:[NSDate distantFuture]]
    /// 方法，内部相当于（是不是不清楚，只能认为相当于）
        /**
             while (true) {
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
             }
         */
    /// 所以在监听的时候，会发现 runloop 实际退出了，然后又开启了一个，进入等待状态
    
    while (!_stop) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    NSLog(@" runloop 结束");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 利用performSelector，在self.thread的线程中调用runInThread方法执行任务
    [self performSelector:@selector(runInThread) onThread:self.thread withObject:nil waitUntilDone:NO];
}


- (void)runInThread{
    
    if (!_stop) {
        dispatch_async(self.queue, ^{
            NSLog(@"haha");
        });
        NSLog(@"RunInThread in thread %@",[NSThread currentThread]);
    }
}


@end

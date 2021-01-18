//
//  BSTimerViewController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/1/15.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSTimerViewController.h"

@interface BSTimerViewController ()


@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger timerCount;

@property (nonatomic ,strong) TimeTarget *timerTarget;

@end

@implementation BSTimerViewController



-(void)dealloc{
    NSLog(@"BSTimerViewController dealloc");
    [self.timer invalidate];
    self.timer = nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTimer];
}


/// repeats = NO 并不会导致循环引用
/// 只有 repeats = YES 才可能导致循环引用
///

-(void)initTimer{
    // repeat = NO 不会造成内存泄漏问题
    [self unRepeatTimer];
    
    // 使用中间对象，解决强引用问题
//    [self initTimerWithTimerTarget];
}



/// 不会导致循环引用
-(void)unRepeatTimer{
    
    /// 如果是block的方式，只要将 self 弱化（weakSelf）即可解决循环引用问题
//    __weak typeof(self)weakSelf = self;
//    self.timer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%@ == %@",timer,self);
//        NSLog(@"timer unrepeat");
//    }];
//    [self.timer fire];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
    
    
    /// 如果是target方式，无论使用weakSelf还是self都会出现循环引用问题
    /// 也不需要 调用 timer invalidate 和 timer = nil
//    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}




-(void)initTimerWithTimerTarget{
    
    self.timerTarget = [TimeTarget alloc];
    self.timerTarget.timerOwner = self;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer fire];

}



-(void)timerAction{
    
    NSLog(@"timerAction == %@",self);
    
}



@end





#pragma mark - TimeTarget ,解决Timer强引用问题
@implementation TimeTarget


-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    
    return [self.timerOwner methodSignatureForSelector:sel];
}


-(void)forwardInvocation:(NSInvocation *)invocation{
    
    [invocation invokeWithTarget:self.timerOwner];
}


@end

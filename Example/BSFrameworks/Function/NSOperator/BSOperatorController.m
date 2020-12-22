//
//  BSOperatorController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/30.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSOperatorController.h"

@interface BSOperatorController ()

@end

@implementation BSOperatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self operatorBlock];
//    [self operatorInvocation];
//    [self operationQueue];
}


-(void)operatorBlock{
    /**
     * block 打印顺序说明
     * currentQueue 的打印 和 thread 的打印是有先后顺序的，两个 currentQueue 打印完成后
     * 才会 打印 thread ， 两个 currentQueue 打印顺序不确定，两个 thread 打印顺序不确定
     * 测试次数 大概 30次
     */
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation block0 = %@\n",[NSOperationQueue currentQueue]);
        NSLog(@"thread block0 = %@\n",[NSThread currentThread]);

    }];

    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation block1 = %@\n",[NSOperationQueue currentQueue]);
        NSLog(@"thread block1 = %@\n",[NSThread currentThread]);
        
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation block2 = %@\n",[NSOperationQueue currentQueue]);
        NSLog(@"thread block2 = %@\n",[NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperation:operation];
//    [queue addOperation:operation1];
    
    // 如果 waitUntilFinished 为 yes 将会等待 数组的 Operation 完成后，
    // 在执行后加入的 Operation，否则一起不确定执行
    [queue addOperations:@[operation,operation2,operation1] waitUntilFinished:NO];
//    [queue addOperation:operation];

    
}


-(void)operatorInvocation{
    
    /**
     * 和block 区别不大，主要是使用 @selector 的方式执行，但是打印顺序是有些区别的
     * 打印的问题 invocation0 和 invocation1 的打印顺序不确定，
     * 但是 thread invocation0 和 thread invocation1 的顺序 一定是在后面的，并且是一起出现
     * 为什么就不清楚了，目前打印结果只出现了两种情况，如下（测试次数在 30次左右）
     */
    
    //    invocation1 = <NSOperationQueue: 0x7ff90700cc70>{name = 'NSOperationQueue 0x7ff90700cc70'}
    //    invocation0 = <NSOperationQueue: 0x7ff90700cc70>{name = 'NSOperationQueue 0x7ff90700cc70'}
    //    thread invocation1 = <NSThread: 0x600003a4ac00>{number = 11, name = (null)}
    //    thread invocation0 = <NSThread: 0x600003a46800>{number = 13, name = (null)}
    //
    //    invocation0 = <NSOperationQueue: 0x7ff905648560>{name = 'NSOperationQueue 0x7ff905648560'}
    //    invocation1 = <NSOperationQueue: 0x7ff905648560>{name = 'NSOperationQueue 0x7ff905648560'}
    //    thread invocation0 = <NSThread: 0x600003a46800>{number = 13, name = (null)}
    //    thread invocation1 = <NSThread: 0x600003a43600>{number = 14, name = (null)}
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invocation0) object:nil];
    
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invocation1) object:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    [queue addOperation:operation1];
}


-(void)invocation0{
    NSLog(@"invocation0 = %@\n",[NSOperationQueue currentQueue]);
    NSLog(@"thread invocation0 = %@\n",[NSThread currentThread]);
}


-(void)invocation1{
    NSLog(@"invocation1 = %@",[NSOperationQueue currentQueue]);
    NSLog(@"thread invocation1 = %@\n",[NSThread currentThread]);
}



-(void)operationQueue{
    
    /**
     * addBarrierBlock 作用，栅栏函数，iOS 13 之后可用
     * 5 个 操作 执行顺序 只有一个是固定的，就是 addBarrierBlock 的回调
     * 它会永远在第三个执行，即：栅栏上边的随机执行，然后栅栏函数，然后栅栏下边的随机执行
     */
    
    NSOperationQueue *quque = [[NSOperationQueue alloc]init];
    
    [quque addOperationWithBlock:^{
        NSLog(@"operation block queue 0");
    }];
    
    [quque addOperationWithBlock:^{
        NSLog(@"operation block queue 1");
    }];
    
    if (@available(iOS 13.0, *)) {
        [quque addBarrierBlock:^{
            NSLog(@"operation block queue 2");
        }];
    }

    [quque addOperationWithBlock:^{
        NSLog(@"operation block queue 3");
    }];
    
    [quque addOperationWithBlock:^{
        NSLog(@"operation block queue 4");
    }];
    
}


@end

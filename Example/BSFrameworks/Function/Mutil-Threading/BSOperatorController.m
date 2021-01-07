//
//  BSOperatorController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/30.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSOperatorController.h"
#import <UIView+BSView.h>

@interface BSOperatorController ()

@property (nonatomic ,strong) dispatch_queue_t queue;

@end

@implementation BSOperatorController

- (void)dealloc
{
    NSLog(@"BSOperatorController delloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
        
    [self studyOperation];
    [self studyGCD];
}


-(void)initView{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 300)];
    label.textAlignment = 0;
    label.numberOfLines = 0;
    label.center = self.view.center;
    label.text = @"线程分为几种方式研究：operation 的 block  ，operation 的 invocation \nGCD的串行队列的异步、同步 ，并发队列的异步同步.\n分别测试他的打印顺序和是否开启新的线程，确定什么时候线程会开启新的线程\n 注意：iOS的队列分为串行队列、并发队列（强调：不是并行，不是并行）";
    
    [self.view addSubview:label];
}




#pragma mark - Operation 测试

/// ====================================================
/// 从打印的 thread 来看，Operation 这几种方式都可能产生新的线程
/// ====================================================


-(void)studyOperation{
    [self operatorBlock];
    [self operatorInvocation];
    [self operationQueue];
}

/**
 * block 和 invocation 两种 NSOperation 子类的测试打印顺序说明
 * currentQueue 的打印 和 thread 的打印是有先后顺序的，两个 currentQueue 打印完成后
 * 才会 打印 thread ， 两个 currentQueue 打印顺序不确定，两个 thread 打印顺序不确定,
 * 是不是必然结果，无法确定
 * 测试次数 大概 30次
 *
 * 个人理解：因为是并发队列，在执行任务的时候，cpu会来回切换线程去执行，
 * 而切换的时机是随机的，所以对于currentQueue和thread打印应该是随机的，虽然出现了上边的结果，
 * 但是因为测试次数少，所以不能肯定打印结果的正确性，也可能是因为切换的算法，可能会导致这种情况出现的概率高
 */

-(void)operatorBlock{
    
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
    
    // waitUntilFinished = yes 将会等待 数组的 Operation 完成后，在执行后加入的 Operation
    // waitUntilFinished = no 时，所有 add 的 operation 执行顺序是随机的
    [queue addOperations:@[operation2,operation1] waitUntilFinished:YES];
    [queue addOperation:operation];

    
}


-(void)operatorInvocation{
    
    //    打印结果目前只测出这两种情况，测试次数 30次左右
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
     * 它会永远在第三个执行
     * 执行顺序：栅栏上边的随机执行，然后栅栏函数，然后栅栏下边的随机执行
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



/// =====================================
/// GCD研究结果
///
/// 1、同一个串行队列下的两个任务如果存在调用关系，那么被调用的如果使用同步操作，
/// 并将同步操作放在这个串行队列下，将会造成相互等待->死锁
///
/// 2、线程是用来执行任务的，队列是用来存放任务的
/// 队列决定了任务是否并发，async 和 sync 决定是否有开启新线程的能力
/// async不是一定会开启新线程的，他只是有能力开启线程
///
/// 3、iOS的队列分为串行队列、并发队列（强调：不是并行，不是并行）
/// 并发是指有能力处理多个任务，不一定同时
/// 并行是指有能力同时处理多个任务，强调的是同时
///
/// 4、主队列 Main Queue ,无论是 同步操作还是异步操作，执行任务都是在主线程 、主队列。
///    说明了 主队列 是不能开辟子线程的。也就是说，子线程的队列永远也不可能是主队列
///
///    延伸1：同样情况的非主线程的串行队列，最多只能创建一个子线程，类似于主队列对应的主线程
///    即：串行队列，无论是不是主队列，只能有一个线程绑定（执行任务是可以在两个线程的）
///    因为主队列系统已经帮我们创建了主线程，所以只有非主串行队列，才会去创建一个新的线程
///
///    延伸2：在串行队列中，主队列可以使用
///    dispatch_async(dispatch_get_main_queue(),^{})方式回到当前线程（主线程）
///    那么非主串行队列queue，在使用 dispatch_async(queue,^{}) 的时候，是否也会回到当前线程？
///    答案是：如果有runloop，那么代码不执行。如果没有runloop，和主线程一样，会回到队列所对应的线程。
///    原因未知，只能猜测，这种情况下，系统对主队列是有不同的处理方式的。
///
/// 5、主队列不会出现在其他线程中，而非主队列可以在主线程中执行（同步操作），也可以在子线程中执行
///
/// 6、dispatch_async(dispatch_get_main_queue(), ^{});方法，永远都会在当前作用域的最后调用
///    跟他调用的位置无关，即 dispatch_async 会将调用他的主方法里的所有其他操作执行完，才会执行
///    dispatch_async ,如果有多个dispatch_async(dispatch_get_main_queue(), ^{});方法
///    按照调用顺序依次执行
///
/// =====================================
#pragma mark - GCD 测试

-(void)studyGCD{

    [self serialQueue];
//    [self concurrentQueueTest];
//    [self globalQueue];
//    [self gcdBarrier];

}


/// 串行队列
/// 1、同步操作 sync ，不会开启新的线程，有死锁的可能，不是只有主队列才死锁
///    如果当前队列是 自定义串行队列 queue，然后把 sync 操作也放入 队列 queue 那么
///    也将会导致死锁
/// 2、异步操作，也会顺序执行，不管多少个异步操作，只会有一个子线程去执行任务
/// 3、如果当前线程的比如说 number 为 5，那么如果推出页面再次进入时，
///    如果线程还是5，这个线程其实是之前的线程，内存地址不变
///    猜测：大概是因为此线程没有释放，但是也没事情做了，当有事情的时候，他又被重新利用了
/// 4、串行队列：只能绑定一条子线程，但是他最多可以在两条线程中执行，除了新创建的线程，
///    还可以通过sync在当前线程中执行，但是我们可以认为是非绑定关系，而是依赖关系。
///    因此才有了主队列执行的任务会回到主线程。而一条线程，是可以在多个队列执行的。
///    而主线程是有对应的runloop的回到主线程后，依然受runloop 影响，但是如果子线程我们自己
///    创建runloop，将当前子线程挂起，通过当前队列回到对应的子线程，发现代码不执行。
///   （需要异步执行任务，如果任务同步的，会导致没有先创建runloop，这时，
///    任务还是可以执行的，因为runloop没执行，就已经完成了任务）（具体原因未知）

#pragma mark 串行队列 SERIAL
-(void)serialQueue{

    //串行队列
    dispatch_queue_t serialqueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
    
    /// 只创建一条线程
    for (int i= 0; i<10; i++) {
        dispatch_async(serialqueue, ^{
            NSLog(@"serialqueue thread i = %d  %@ " ,i,[NSThread currentThread]);
        });
    }
    
    
    
    /// 死锁
    // 下边dispatch_sync如果使用主队列的话，会造成死锁，
    // 因为 serialQueue 方法 是在主队列进行的，而在主队列进行的同步操作，
    // 需要等待serialQueue方法执行完才会执行dispatch_sync，
    // 但是 serialQueue 方法也在等待 dispatch_sync 执行完才能完结方法，造成了相互等待，死锁

    
    /// 死锁案例1 ，主队列
    //[dispatch_sync(dispatch_get_main_queue(), ^{
    //  NSLog(@"syn serialqueue thread 1%@ " ,[NSThread currentThread]);
    //})] ;
    
    
    /// 死锁案例2 自定义串行队列
    //dispatch_queue_t serialqueueLock = dispatch_queue_create("serialqueueLock", DISPATCH_QUEUE_SERIAL);
    //
    //dispatch_async(serialqueueLock, ^{
    //
    //  dispatch_sync(serialqueueLock, ^{
    //      NSLog(@"死锁，无法打印");
    //  });
    //});
    
    
    /// 测试自定义串行队列和主队列的是否相同，验证主队列是否特殊
//    [self backSerialQueue];
}





/// =====================================
/// 通过自定义串行队列，返回到对应线程
///
/// 测试结论：通过当前队列，我们可以回到队列第一次创建的线程中。
/// 就如 dispatch_async(dispatch_get_main_queue()) 可以回到主线程一样。
/// 而这两种情况的区别在于，主线程有对应的runloop,会到主线程，会调用runloop。
/// 而子线程如果调用runloop，dispatch_async(queue)方法不会执行
///
/// dispatch_async(dispatch_get_main_queue(), ^{});方法，永远都会在当前作用域的最后调用
/// 跟他调用的位置无关，即 dispatch_async 会将调用他的主方法里的所有其他操作执行完，才会执行
/// dispatch_async mainqueue ,如果有多个dispatch_async(dispatch_get_main_queue(), ^{})
/// 会按照调用顺序依次执行（下边的打印 dispatch_get_main_queue 1、2、3号会依次执行，
/// 而且会在所有打印之后打印）
///
/// 而如果使用自定义串行队列模仿主队列，发现打印结果并不是如此。
///
/// =====================================

-(void)backSerialQueue{
    
    // 验证 自定义串行队列是否如同主线程一样，可以通过队列返回到对应线程
    
    dispatch_queue_t quque = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(quque, ^{

        NSLog(@"quque 首次进入");
        dispatch_queue_t quque1 = dispatch_queue_create("myqueue1", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(quque1, ^{
            NSLog(@"quque 1 进入");
        });
        
        dispatch_async(quque, ^{
            NSLog(@"这里不执行，如果去掉runloop 就可以执行 ");
        });
        
        dispatch_async(quque1, ^{
            NSLog(@"quque 2 进入");
        });
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runloop runUntilDate:[NSDate distantFuture]];
    });
    
    
      ///验证 dispatch_get_main_queue 的打印顺序
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"dispatch_get_main_queue 1 号");
//    });
//    [self testMain];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"dispatch_get_main_queue 3号");
//    });
    
    
    /// 验证线程和串行队列绑定问题
    
//    dispatch_queue_t quque = dispatch_queue_create("mySerialQueue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_async(quque, ^{
//
//        dispatch_queue_t quque1 = dispatch_queue_create("mySerialQueue1", DISPATCH_QUEUE_SERIAL);
//        dispatch_sync(quque1, ^{
//
//        });
//
//        dispatch_async(quque1, ^{
//
//        });
//
//    });
    
}


-(void)testMain{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_get_main_queue 2号");
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"dispatch_get_global_queue 1号");
    });
}







/// CONCURRENT 并发队列
/// 1、async 异步操作可能会创建新的线程，多个异步操作创建的线程数不确定，
///    可能有两个或两个以上的异步操作使用同一个线程
/// 2、sync 同步操作不会创建新的线程，所以执行任务的时候是在当前线程执行的，也就是说，
///    当前如果是主线程，那么他就在主线程执行，当前如果是子线程，那么他就在子线程执行
///    对于队列，任务加到哪个队列就在哪个队列执行。典型案例：主线程执行其他队列任务
#pragma mark 并发队列 CONCURRENT
-(void)concurrentQueueTest{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentqueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(concurrentQueue, ^{
        NSLog(@"async concurrentQueue thread 1%@ " ,[NSThread currentThread]);
    });

    dispatch_async(concurrentQueue, ^{
        NSLog(@"async concurrentQueue thread 2%@ " ,[NSThread currentThread]);
    });
    
    
    /// 这个打印结果证明： sync 同步操作不会创建新的线程，执行任务的时候是在当前线程执行的，也就是说，
    /// 当前如果是主线程，那么他就在主线程执行，当前如果是子线程，那么他就在子线程执行
//    dispatch_async(concurrentQueue, ^{
//
//        NSLog(@"=== async concurrentQueue thread 1%@ " ,[NSThread currentThread]);
//        NSLog(@"=== async queue = %@  == %p" ,dispatch_get_current_queue(),dispatch_get_current_queue());
//
//        dispatch_sync(concurrentQueue, ^{
//            NSLog(@"=== sync concurrentQueue thread 3%@ " ,[NSThread currentThread]);
//            NSLog(@"=== sync queue %@ == %p " ,dispatch_get_current_queue(),dispatch_get_current_queue());
//        });
//
//    });
    
    
    /// sync 不会开启新的线程，所以会在 当前线程（concurrentQueueTest在主线程）
    /// 队列为 concurrentQueue 。但是有点需要注意，当使用
    /// [NSOperationQueue currentQueue]时，发现打印的是 主队列，
    /// 为什么是主队列不清楚，但是从堆栈来看，是在 concurrentQueue 队列中
    /// 而且我们在使用GCD 的时候，其实是不能使用 NSOperationQueue 来获取当前队列的
    /// [NSOperationQueue currentQueue] 只适用于 NSOperationQueue 类创建的队列
    /// 而 GCD 应该使用 dispatch_get_current_queue() 来获取。而 dispatch_get_current_queue()
    /// 在iOS 6时，已经被废弃，但是依然可以调用，调用的时候最好把他以临时变量的方式来使用
    /// 否则可能导致崩溃

//    dispatch_sync(concurrentQueue, ^{
//        NSLog(@"sync concurrentQueue thread 1%@ " ,[NSThread currentThread]);
//    });

}



/// 对于全局并发队列 dispatch_get_global_queue
/// 全局并发队列的第一个参数为 优先级，第二个参数是扩展参数，目前没有用
/// 优先级有4个值，我们在 dispatch_get_global_queue 获取队列的时候，
/// 4个值对应的是四个不同的队列，但是每个值，只会创建一个队列，也就是说实际上，
/// 通过dispatch_get_global_queue最多只能创建4个队列，通过队列的地址可以
/// 看出同一个优先级参数，对应的队列的内存地址是一个

#pragma mark 全局队列 GLOBAL
-(void)globalQueue{
    
    dispatch_queue_t globalqueue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(globalqueue, ^{
        NSLog(@"async global thread %@ " ,[NSThread currentThread]);
        NSLog(@"%p",globalqueue);
    });

    
    dispatch_queue_t globalqueue1 = dispatch_get_global_queue(0, 0);

    dispatch_async(globalqueue1, ^{
        NSLog(@"async global thread 1%@ " ,[NSThread currentThread]);
        NSLog(@"%p",globalqueue1);
    });

    dispatch_queue_t globalqueue2 = dispatch_get_global_queue(0, 0);

    dispatch_async(globalqueue2, ^{
        NSLog(@"async global thread 2%@ " ,[NSThread currentThread]);
        NSLog(@"%p",globalqueue2);
    });

    
    dispatch_queue_t highQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_async(highQueue, ^{
        NSLog(@"async global thread 3%@ " ,[NSThread currentThread]);
        NSLog(@"HIGH %p",highQueue);
    });


    dispatch_queue_t highQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_async(highQueue1, ^{
        NSLog(@"async global thread 4%@ " ,[NSThread currentThread]);
        NSLog(@"HIGH %p",highQueue1);
    });
    
    
    
    
    dispatch_queue_t highQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_sync(highQueue2, ^{
        NSLog(@"==sync global thread 5%@ " ,[NSThread currentThread]);
        NSLog(@"HIGH %p",highQueue2);
    });
    
    
    
    dispatch_queue_t highQueue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_sync(highQueue3, ^{
        NSLog(@"==sync global thread 6%@ " ,[NSThread currentThread]);
        NSLog(@"HIGH %p",highQueue3);
    });
}


// 栅栏 GCD 的栅栏 ，只适用于自定义 并发队列，
// 如果是 全局并发队列，效果和 dispatch_async 相同

-(void)gcdBarrier{
    
    /// dispatch_barrier_async 的官方说明
    /// 大概意思是：只能用于 DISPATCH_QUEUE_CONCURRENT queues
    
    /*!
     * @function dispatch_barrier_async
     *
     * @abstract
     * Submits a barrier block for asynchronous execution on a dispatch queue.
     *
     * @discussion
     * Submits a block to a dispatch queue like dispatch_async(), but marks that
     * block as a barrier (relevant only on DISPATCH_QUEUE_CONCURRENT queues).
     *
     * See dispatch_async() for details and "Dispatch Barrier API" for a description
     * of the barrier semantics.
     *
     * @param queue
     * The target dispatch queue to which the block is submitted.
     * The system will hold a reference on the target queue until the block
     * has finished.
     * The result of passing NULL in this parameter is undefined.
     *
     * @param block
     * The block to submit to the target dispatch queue. This function performs
     * Block_copy() and Block_release() on behalf of callers.
     * The result of passing NULL in this parameter is undefined.
     */
    
//    dispatch_queue_t myQueue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);

    
    dispatch_async(myQueue, ^{
        
        NSLog(@"1");
    });
    
    dispatch_async(myQueue, ^{
        
        NSLog(@"2");
    });
    
    dispatch_barrier_async(myQueue, ^{
        NSLog(@"3");
    });
    
    dispatch_async(myQueue, ^{
        
        NSLog(@"4");
    });
    
    dispatch_async(myQueue, ^{
        
        NSLog(@"5");
    });
    
}



@end

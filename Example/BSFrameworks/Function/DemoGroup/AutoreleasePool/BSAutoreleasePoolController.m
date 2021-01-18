//
//  BSAutoreleasePoolController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/17.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSAutoreleasePoolController.h"

@interface BSAutoreleasePoolController ()

@property (nonatomic ,copy) NSString *tempStr;

@property (nonatomic ,strong) NSString *strongStr;
@property (nonatomic ,weak) NSString *weakStr;

@end

@implementation BSAutoreleasePoolController


__weak NSString *weak_String;
__weak NSString *weak_StringAutorelease;

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self end];
    
    [self weakStrongStr];
}


/// 对于 [NSString stringWithFormat:@"string1"] 来说，内存是在全局区
/// 不会释放，strongStr 和 weakStr 都指向了这个内存地址，虽然 strongStr = nil 了
/// 但是因为内存地址不受指针影响，所以 weakStr 依然指向 [NSString stringWithFormat:@"string1"];
/// 地址，所以最后打印值为 string1
/// 如果换成 [[NSString alloc]initWithFormat:@"ajlksdjflakdsjflkadf"];因为是CFString类型
/// 在堆区，我们自己管理，当 strongStr = nil 的时候，这个内存释放, weakStr 置空
/// 如果alloc init初始化 的字符串比较短，如 [[NSString alloc]initWithFormat:@"aa"]
/// 那么这个字符串对象的类型是 tagpoint ,在栈区。有关字符串类型和内存分区 需要在详细研究，
/// 设计的东西比较多。详情查看链接： https://www.jianshu.com/p/188451d0fe60
///
-(void)weakStrongStr{
    
    self.strongStr = [NSString stringWithFormat:@"string1"];
//    self.strongStr = [[NSString alloc]initWithFormat:@"ajlksdjflakdsjflkadf"];

    self.weakStr = _strongStr;
    NSLog(@"%p==%p",self.strongStr,self.weakStr);
    
    self.strongStr = nil;
    
    NSLog(@"%p==%p",self.strongStr,self.weakStr);
    NSLog(@"%p==%p",[NSString stringWithFormat:@"string1"],self.weakStr);

    NSLog(@"%@",self.weakStr); // string1
}


-(void)begin{
    
    NSString *string = [[NSString alloc] initWithFormat:@"Hello, World!"];    // 创建常规对象
    NSString *stringAutorelease = [NSString stringWithFormat:@"Hello, World! Autorelease"]; // 创建autorelease对象
    weak_String = string;
    weak_StringAutorelease = stringAutorelease;
}


-(void)end{
    
    /**
     * 测试发现，autorelease型变量的生命周期不受作用域控制，
     * 只受 @autoreleasepool 控制，所以 weak_StringAutorelease 在
     * 自动释放池内，虽然出了 begin 方法，但是仍然能打印，但是 weak_String 出了作用域已经释放了
     */

    @autoreleasepool {
        [self begin];
        NSLog(@"@autoreleasepool 内：%@",weak_String);
        NSLog(@"@autoreleasepool 内：%@",weak_StringAutorelease);
    }

    NSLog(@"----%@",weak_String);
    NSLog(@"----%@",weak_StringAutorelease);

    NSString *ss = [[NSString alloc]initWithFormat:@"123123123123"];
    self.tempStr = ss;
}


@end

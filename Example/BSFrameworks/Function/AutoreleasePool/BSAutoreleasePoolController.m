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

@end

@implementation BSAutoreleasePoolController


__weak NSString *weak_String;
__weak NSString *weak_StringAutorelease;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self end];
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

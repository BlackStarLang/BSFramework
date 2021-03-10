//
//  BSCalculationRoot.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/21.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSCalculationRoot.h"
#import "BSHuiwenStr.h"
#import "BSMaxHundredNumber.h"
#import "BSFibonacciSequence.h"
#import "BSSort.h"

@interface BSCalculationRoot ()

@end

@implementation BSCalculationRoot


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"算法集锦";
    // Do any additional setup after loading the view.
    
//    // 验证某个字符串是否含有4位以上的回文字符串
//    [self huiwenStr];
//
//    // 不改变数组里的元素顺序，找三个数字，组成最大的三位数
//    [self maxHundredNumber];
//
//    // 输出长度为N的 斐波那契数列
//    [self fibonacciSeqence];
    
    //排序
    [self sort];
}




-(void)huiwenStr{
    
    NSString *rangeStr = @"jalsdfkkkakkdalajdkfkakdkd";
    
    BSHuiwenStr *huiwen = [[BSHuiwenStr alloc]init];
    BOOL hasHuiwen = [huiwen isHuiwenWithStr:rangeStr];
    NSLog(@"%@",hasHuiwen?@"有回文字符串":@"无回文字符串");
}




-(void)maxHundredNumber{
    NSArray *arr = @[@"8",@"9",@"2",@"3",@"5",@"6",@"7",@"0",@"1",@"4"];
    
    NSLog(@"最大三位数为：%ld",[BSMaxHundredNumber getMaxHundredWithSingleNumberArray:arr]);
}



-(void)fibonacciSeqence{
    NSString *length = @"10";
    NSArray *arr = [BSFibonacciSequence getFibonacciArrayWithNumberN:length.integerValue];
    NSString *fibonacciStr = [arr componentsJoinedByString:@","];
    NSLog(@"\n斐波那契数列：n=%@\n%@",length,fibonacciStr);
}


-(void)sort{
    //@[@"5",@"3",@"2",@"4",@"6",@"9",@"8",@"1",@"99",@"66"]
    NSArray *sortArr = @[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    
    NSArray *arr = [BSSort maopaoSortWithArray:sortArr];
    
    NSLog(@"%@",[arr componentsJoinedByString:@","]);
}

@end

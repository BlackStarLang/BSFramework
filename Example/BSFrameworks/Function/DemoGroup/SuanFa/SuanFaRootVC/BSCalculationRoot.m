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

@interface BSCalculationRoot ()

@end

@implementation BSCalculationRoot


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"算法集锦";
    // Do any additional setup after loading the view.
    
    // 验证某个字符串是否含有4位以上的回文字符串
    [self huiwenStr];
    
    //不改变数组里的元素顺序，找三个数字，组成最大的三位数
    [self maxHundredNumber];
    
    
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



@end

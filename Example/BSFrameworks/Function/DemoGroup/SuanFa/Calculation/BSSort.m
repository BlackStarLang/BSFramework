//
//  BSSort.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/5.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSSort.h"

@implementation BSSort


+(NSArray*)maopaoSortWithArray:(NSArray *)arr{
    
    NSMutableArray *sortArr = [arr mutableCopy];
    // 利用数组交换进行冒泡
    // @[@"5",@"3",@"2",@"4",@"6",@"9",@"8",@"1",@"99",@"66"]]
    int count = 0;
    for (int i = 0; i < sortArr.count-1; i++) {

        for (int j = i+1; j<sortArr.count; j++) {

            if ([sortArr[i] integerValue] > [sortArr[j] integerValue]) {
//                NSLog(@"%@",[sortArr componentsJoinedByString:@","]);
                [sortArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }

            count ++;
        }

    }
    NSLog(@"普通冒泡排序 循环次数：%d：%@",count,[sortArr componentsJoinedByString:@","]);
    
    
    /// 通过以下方式，可以减少循环次数
    int count1 = 0;
    NSMutableArray *ns = [NSMutableArray array];
   
    for (int i = 0; i < arr.count; i++) {
        
        NSInteger temp = [arr[i] integerValue];

        if (ns.count<=0) {
            [ns addObject:[NSString stringWithFormat:@"%ld",(long)temp]];
            count1 ++;
            continue;
        }
        
        for (int j = 0; j<=ns.count; j++) {
            count1 ++;
            
            if (j == ns.count) {
                [ns insertObject:[NSString stringWithFormat:@"%ld",(long)temp] atIndex:j];
                break;
            }
            
            if (temp <= [ns[j] integerValue]) {
                [ns insertObject:[NSString stringWithFormat:@"%ld",(long)temp] atIndex:j];
                break;
            }
            
        }
    }
    
    NSLog(@"优化算法 循环次数：%d：%@",count1,[ns componentsJoinedByString:@","]);
    
    return [sortArr copy];
}


@end

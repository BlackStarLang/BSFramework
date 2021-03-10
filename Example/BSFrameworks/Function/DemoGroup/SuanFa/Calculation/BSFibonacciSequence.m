//
//  BSFibonacciSequence.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/5.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSFibonacciSequence.h"

@implementation BSFibonacciSequence


/// 输出 Fn(n) 斐波那契数组 (n = 0 , array[0] = 1)

+(NSArray*)getFibonacciArrayWithNumberN:(NSInteger)numberN{
    
    if (numberN<2) {
        NSLog(@"numberN 不能小于2");
        return @[];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@1,@1]];
            
    for ( NSInteger i = 2; i < numberN; i++) {
        NSNumber *first = array[i-1];
        NSNumber *last = array[i-2];

        NSInteger sum = first.integerValue + last.integerValue;
        NSNumber *sumNumber = [NSNumber numberWithInteger:sum];
        [array addObject:sumNumber];
    }
    
    
    
    return array;
}

@end

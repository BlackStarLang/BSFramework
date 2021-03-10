//
//  BSFibonacciSequence.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/5.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 斐波那契 数列

@interface BSFibonacciSequence : NSObject

/// 输出 Fn(n) 斐波那契数组 (n = 0 , array[0] = 1)
+(NSArray*)getFibonacciArrayWithNumberN:(NSInteger)numberN;

@end

NS_ASSUME_NONNULL_END

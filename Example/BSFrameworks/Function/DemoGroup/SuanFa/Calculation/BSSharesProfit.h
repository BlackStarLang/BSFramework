//
//  BSSharesProfit.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2022/10/2.
//  Copyright © 2022 blackstar_lang@163.com. All rights reserved.
//

///====================================
/// MARK: Class 说明
/// Desc: 股票最大利润计算:
/// 给你一个整数数组 prices ，其中 prices[i] 表示某支股票第 i 天的价格。
/// 在每一天，你可以决定是否购买和/或出售股票。
/// 你在任何时候 最多 只能持有 一股 股票。你在购买后，最少隔一天才能卖出（T+1）
/// 返回 你能获得的 最大 利润 。
///
/// Author : BlackStar
///====================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSSharesProfit : NSObject

+(NSNumber *)getSharesProfitWithPrices:(NSArray *)prices;

@end

NS_ASSUME_NONNULL_END

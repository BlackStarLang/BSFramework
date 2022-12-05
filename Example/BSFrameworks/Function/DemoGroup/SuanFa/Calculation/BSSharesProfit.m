//
//  BSSharesProfit.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2022/10/2.
//  Copyright © 2022 blackstar_lang@163.com. All rights reserved.
//

#import "BSSharesProfit.h"

@implementation BSSharesProfit

+(NSNumber *)getSharesProfitWithPrices:(NSArray *)prices{
    
    {
        ///递归方式
        if (prices.count <= 1)return [NSNumber numberWithInteger:0];
        NSInteger profit = [self getPairValueForProfitWithStartIndex:0 prices:prices profit:0];
        return [NSNumber numberWithFloat:profit];
    }

    {
        ///循环方式
        return [self getSharesProfitFunc2:prices];
    }
}


#pragma mark - 方法1 递归
+(CGFloat)getPairValueForProfitWithStartIndex:(NSInteger)index prices:(NSArray *)prices profit:(CGFloat)profit{
    
    if (prices.count < index+1) return profit;
    
    CGFloat buyPrice = [(NSNumber *)prices[index] floatValue];
    
    for (NSInteger i = index+1; i < prices.count ; i++) {
           
        CGFloat curPrice = [(NSNumber *)prices[i] floatValue];

        if(buyPrice > curPrice)
        {
            buyPrice = curPrice;
        }
        else
        {
            CGPoint salePriceP = [self getSalePriceWithIndex:i prices:prices];
            profit = MAX(profit + salePriceP.x - buyPrice, 0);
            NSLog(@"%.f - %.f    (%.f,%.f)",salePriceP.x,buyPrice,i,salePriceP.y);
            profit = [self getPairValueForProfitWithStartIndex:salePriceP.y prices:prices profit:profit];
            break;
        }
    }

    return profit;
}


+(CGPoint)getSalePriceWithIndex:(NSInteger)index prices:(NSArray *)prices {
        
    CGFloat salePrice = [(NSNumber *)prices[index] floatValue];
    
    NSInteger nextBuyIndex = index;
    for (NSInteger i = index+1; i < prices.count ; i++) {
           
        CGFloat curPrice = [(NSNumber *)prices[i] floatValue];
        nextBuyIndex = i;

        if(salePrice > curPrice)
        {
            break;
        }
        else
        {
            salePrice = curPrice;
        }
    }
    return CGPointMake(salePrice, nextBuyIndex);
}



#pragma mark -  方法2
+(NSNumber *)getSharesProfitFunc2:(NSArray *)prices
{
    NSNumber *totalNumber = [NSNumber numberWithFloat:0];
    NSInteger index = 0;
    
    for (NSInteger i = index; i < prices.count-1; i++) {
        
        NSNumber *curNumber = prices[i];
        NSNumber *nextNumber = prices[i+1];

        if(curNumber > nextNumber)
        {
            continue;
        }
        else
        {
            for (NSInteger j = i; j < prices.count-1; j++) {
                
                NSNumber *saleCurNumber = prices[j];
                NSNumber *saleNextNumber = prices[j+1];
                
                if(saleCurNumber > saleNextNumber)
                {
                     
                }
            }
        }
    }
    return totalNumber;
}

@end

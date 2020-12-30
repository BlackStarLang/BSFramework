//
//  BSMaxHundredNumber.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/29.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSMaxHundredNumber.h"

@implementation BSMaxHundredNumber

+(NSInteger)getMaxHundredWithSingleNumberArray:(NSArray *)singleNumberArray{
    
    
    int h = 0;
    int s = 0;
    int g = 0;
    int hindex = 0;
    
    // 找到百位
    for (int i =0 ; i< singleNumberArray.count - 2 ; i++){
        NSString  *temp = singleNumberArray[i];
        if (temp.intValue>h) {
            hindex = i;
        }
        h = MAX(h,temp.intValue);
    }
    
    int sindex = 0;
    // 找到十位
    for (int i =hindex+1 ; i< singleNumberArray.count -1 ; i++){
        NSString  *temp = singleNumberArray[i];
        if (temp.intValue>s) {
            sindex = i;
        }
        s = MAX(s,temp.intValue);
    }
    
    // 找到个位
    for (int i =sindex+1 ; i< singleNumberArray.count ; i++){
        NSString  *temp = singleNumberArray[i];
        g = MAX(g,temp.intValue);
    }
    
    int maxValue = h*100 + s*10 + g;
    return maxValue;
}


@end

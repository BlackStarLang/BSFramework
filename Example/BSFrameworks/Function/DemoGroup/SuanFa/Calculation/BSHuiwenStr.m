//
//  BSHuiwenStr.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/21.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSHuiwenStr.h"

@implementation BSHuiwenStr

-(BOOL)isHuiwenWithStr:(NSString *)str{
    
    if (str.length<4) {
        return NO;
    }else if (str.length==4){
        
        return [self fourStrIsHuiwen:str];
        
    }else{
        
        NSArray *fourArr = [self getTargetStrArrayWithStr:str length:4];
        NSArray *fiveArr = [self getTargetStrArrayWithStr:str length:5];

        for (NSString *fourStr in fourArr) {
            if ([self fourStrIsHuiwen:fourStr]) {
                return YES;
            }
        }

        for (NSString *fiveStr in fiveArr) {
            if ([self fiveStrIsHuiwen:fiveStr]) {
                return YES;
            }
        }
    }
    return NO;
}


-(NSArray *)getTargetStrArrayWithStr:(NSString *)str length:(NSInteger)length{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<str.length - length; i++) {
        NSRange range = NSMakeRange(i, length);
        NSString *targetStr = [str substringWithRange:range];
        [arr addObject:targetStr];
    }
    
    return arr;
}


-(BOOL)fourStrIsHuiwen:(NSString *)fourStr{
    
    NSString *str = fourStr;
    
    NSMutableString *mutStr = [NSMutableString string];
    
    [str enumerateSubstringsInRange:NSMakeRange(0, fourStr.length) options:NSStringEnumerationReverse|NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
       
        [mutStr appendString:substring];
        
    }];
    
    NSLog(@"%@ == %@",fourStr,mutStr);
    
    if ([mutStr isEqualToString:fourStr]) {
        return YES;
    }
    
    return NO;
}


-(BOOL)fiveStrIsHuiwen:(NSString *)fiveStr{
    NSString *str = fiveStr;
    
    NSMutableString *mutStr = [NSMutableString string];
    
    [str enumerateSubstringsInRange:NSMakeRange(0, fiveStr.length) options:NSStringEnumerationReverse|NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        [mutStr appendString:substring];
    }];
    
    NSLog(@"== %@ == %@",fiveStr,mutStr);
    
    if ([mutStr isEqualToString:fiveStr]) {
        return YES;
    }
    return NO;
}


@end

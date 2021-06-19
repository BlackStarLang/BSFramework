//
//  NSNotificationCenter+BSNotiCenter.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "NSNotificationCenter+BSNotiCenter.h"

@implementation NSNotificationCenter (BSNotiCenter)

-(void)removeObserver:(id)observer{
    NSLog(@"removeObserver %@",[observer class]);
}




@end

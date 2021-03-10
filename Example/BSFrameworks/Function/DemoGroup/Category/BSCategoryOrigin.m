//
//  BSCategoryOrigin.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryOrigin.h"
#import <objc/runtime.h>

@implementation BSCategoryOrigin

-(void)showTotalInfo{
    
    unsigned pcount = 0;
    Ivar *ivars = class_copyIvarList([self class], &pcount);
    
    for (int i = 0; i<pcount; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString *ocName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"ivar:%@",ocName);
    }
    
    
    unsigned mcount ;
    Method * methodList = class_copyMethodList([self class], &mcount);
    
    for (int i = 0; i<mcount; i++) {
        Method method = methodList[i];
        SEL selMethod = method_getName(method);
        NSString *selName = NSStringFromSelector(selMethod);
        NSLog(@"method:%@ ",selName);
    }
}


-(void)test{
    NSLog(@"test");
}


@end

//
//  BSObjcPerson.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/19.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSObjcPerson.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation BSObjcPerson

-(void)dealloc{
    NSLog(@"BSObjcPerson dealloc %p",self);
}

@end


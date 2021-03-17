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


-(void)setReName:(NSString *)reName{
    /// 当 automaticallyNotifiesObserversForKey return no 的时候
    /// 想要触发kvo，需要将 willChangeValueForKey 和 didChangeValueForKey
    /// 全部调用，才会触发kvo，否则将不会触发kvo
    [self willChangeValueForKey:@"reName"];
    _reName = reName;
    [self didChangeValueForKey:@"reName"];
}


+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    if ([key isEqualToString:@"reName"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

@end


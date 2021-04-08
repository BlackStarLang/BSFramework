//
//  BSNotificationObj.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSNotificationObj.h"
#import "NSNotificationCenter+BSNotiCenter.h"


@implementation BSNotificationObj

-(void)dealloc{
    NSLog(@"dealloc : %@",[self class]);
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initNoti];
    }
    return self;
}


-(void)initNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(objNoti) name:@"objNoti" object:nil];
}



-(void)objNoti{
    NSLog(@"objNoti : %@---%@",[self class],[NSThread currentThread]);
}


@end

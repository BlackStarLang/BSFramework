//
//  BSNotificationView.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSNotificationView.h"

@implementation BSNotificationView

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewNoti) name:@"viewNoti" object:nil];
}



-(void)viewNoti{
    NSLog(@"viewNoti : %@---%@",[self class],[NSThread currentThread]);
}


@end

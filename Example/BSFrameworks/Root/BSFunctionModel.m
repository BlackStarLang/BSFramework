//
//  BSFunctionModel.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/2.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSFunctionModel.h"

@implementation BSFunctionModel


-(void)getFunctionArr{

    _funcArr = [NSMutableArray array];
    
    NSDictionary *dic = [self getInfoDic];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        BSFunctionItem *item = [[BSFunctionItem alloc]init];
        item.title = key;
        item.pushTargetName = obj;
        
        [_funcArr addObject:item];
    }];
    
}


-(NSDictionary *)getInfoDic{
    
    NSDictionary *pushInfo = @{@"3D轮播图":@"BSLooperViewVC",
                               @"选择图片控件，拍照+视频（自定义相机）":@"BSPhotoVC",
                               @"runloop 研究":@"BSStudyObjcController",
                               @"动态行为 Dynamic Behavior":@"BSDynamicBehavior",
                               @"自定义上下拉刷新 discard":@"BSRefreshController",
                               @"转场动画，UIView Transition 动画": @"BSTransitionController",
                               @"自定义 alertcontroller": @"BSAlertController",
                               @"多线程研究，GCD 和 NSOperation":@"BSOperatorController",
                               @"WKWebView":@"BSWebViewController",
                               @"AutoreleasePool ":@"BSAutoreleasePoolController",
                               @"自定义KVO，用于更好地理解kvo原理 ":@"BSKVOTestController",
                               @"算法集锦":@"BSCalculationRoot",
                               
    };
    
    return pushInfo;
}


@end


@implementation BSFunctionItem




@end

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
        
        if ([key isEqualToString:@"Demo合集"]) {
            [_funcArr addObject:item];
        }else{
            [_funcArr insertObject:item atIndex:0];
        }
    }];
}


-(void)getSubFuncArr{
    
    _subFuncArr = [NSMutableArray array];
    
    NSDictionary *dic = [self demoGroup];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

        BSFunctionItem *item = [[BSFunctionItem alloc]init];
        item.title = key;
        item.pushTargetName = obj;
        [_subFuncArr addObject:item];
    }];
    
}



/// 列表第一层数据
-(NSDictionary *)getInfoDic{
    
    NSDictionary *pushInfo = @{@"Pod 组件：3D轮播图":@"BSLooperViewVC",
                               @"Pod 组件：选择图片控件，拍照+视频（自定义相机）":@"BSPhotoVC",
                               @"Demo合集":@"BSSubFuncListController",
                               
    };
    
    return pushInfo;
}


/// demo学习数据
-(NSDictionary *)demoGroup{
    
    NSDictionary *subDic = @{@"runloop 研究":@"BSStudyObjcController",
                             @"动态行为 Dynamic Behavior":@"BSDynamicBehavior",
                             @"自定义上下拉刷新 discard":@"BSRefreshController",
                             @"转场动画，UIView Transition 动画": @"BSTransitionController",
                             @"自定义 alertcontroller": @"BSAlertController",
                             @"多线程研究，GCD 和 NSOperation":@"BSOperatorController",
                             @"WKWebView":@"BSWebViewController",
                             @"AutoreleasePool ":@"BSAutoreleasePoolController",
                             @"自定义KVO，用于更好地理解kvo原理 ":@"BSKVOTestController",
                             @"算法集锦":@"BSCalculationRoot",
                             @"Block 研究":@"BSBlockController",
                             @"Timer":@"BSTimerViewController",
                             @"Category研究：方法加载、重写":@"BSCategoryVC",
    };
    
    return subDic;
}


@end


@implementation BSFunctionItem




@end

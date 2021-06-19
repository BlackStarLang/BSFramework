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
    
    NSArray *arr = [self getInfoDic];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        BSFunctionItem *item = [[BSFunctionItem alloc]init];
        item.title = dic.allKeys.firstObject;
        item.pushTargetName = dic.allValues.firstObject;
        [_funcArr addObject:item];
    }];
}


-(void)getSubFuncArr{
    
    _subFuncArr = [NSMutableArray array];
    
    NSArray *arr = [self demoGroup];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        
        BSFunctionItem *item = [[BSFunctionItem alloc]init];
        item.title = dic.allKeys.firstObject;
        item.pushTargetName = dic.allValues.firstObject;
        [_subFuncArr addObject:item];
    }];
}



/// 列表第一层数据
-(NSArray *)getInfoDic{
    
    NSArray *pushInfo = @[@{@"Pod 组件：3D轮播图":@"BSLooperViewVC"},
                          @{@"Pod 组件：选择图片控件，拍照+视频（自定义相机）":@"BSPhotoVC"},
                          @{@"Pod 组件：Socket，即时通讯":@"BSSocketViewController"},
                          @{@"Pod 组件：网络视频预加载":@"BSVideoPlayerVC"},
                          @{@"Demo合集":@"BSSubFuncListController"},
    ];
    
    return pushInfo;
}


/// demo学习数据
-(NSArray *)demoGroup{
    
    NSArray *subArr = @[@{@"runloop 研究，所在位置 ：DemoGroup/Runloop":@"BSStudyObjcController"},
                        @{@"动态行为 Dynamic Behavior，所在位置 ：DemoGroup/DynamicBehavior":@"BSDynamicBehavior"},
                        @{@"自定义上下拉刷新 discard，所在位置 ：DemoGroup/TableViewRefresh":@"BSRefreshController"},
                        @{@"转场动画，UIView Transition 动画，所在位置 ：DemoGroup/TransitionAnimate": @"BSTransitionController"},
                        @{@"自定义 alertcontroller，所在位置 ：DemoGroup/AlertController": @"BSAlertController"},
                        @{@"多线程研究，GCD 和 NSOperation，所在位置 ：DemoGroup/Mutil-Threading":@"BSOperatorController"},
                        @{@"WKWebView，所在位置 ：DemoGroup/WKWebView":@"BSWebViewController"},
                        @{@"AutoreleasePool，所在位置 ：DemoGroup/AutoreleasePool":@"BSAutoreleasePoolController"},
                        @{@"自定义KVO，用于更好地理解kvo原理 ，所在位置 ：DemoGroup-BSNotifacation_KVO":@"BSKVOTestController"},
                        @{@"算法集锦，所在位置 ：DemoGroup-SuanFa":@"BSCalculationRoot"},
                        @{@"Block 研究，所在位置 ：DemoGroup/Block":@"BSBlockController"},
                        @{@"Timer，所在位置 ：DemoGroup/Timer":@"BSTimerViewController"},
                        @{@"Category研究方法加载、重写，所在位置 ：DemoGroup/Category":@"BSCategoryVC"},
                        @{@"消息转发机制，所在位置 ：DemoGroup/MethodMsgSend":@"BSMsgSendForMethod"},
                        @{@"滚动视图联动，所在位置 ：DemoGroup/MutiscrollView":@"BSContainerVC"},
                        @{@"通知 NSNotificationCenter，所在位置 ：DemoGroup/Notification":@"BSNotificationPostVC"},
                        @{@"事件响应链，所在位置 ：DemoGroup/HitTest":@"BSResponseChainVC"},
    ];
    
    return subArr;
}


@end


@implementation BSFunctionItem




@end

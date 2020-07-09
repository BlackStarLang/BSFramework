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
                               @"自定义相机 + 拍照水印 + 图片选择器 + 预览等图片相关":@"BSPhotoVC",
                               @"自定义kvo，用于更好地理解kvo原理":@"BSStudyObjcController",
                               @"动态行为 Dynamic Behavior":@"BSDynamicBehavior",
                               
    };
    
    return pushInfo;
}


@end


@implementation BSFunctionItem




@end

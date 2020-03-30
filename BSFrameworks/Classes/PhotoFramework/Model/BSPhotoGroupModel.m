//
//  BSPhotoGroupModel.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import "BSPhotoGroupModel.h"
#import <Photos/Photos.h>


@implementation BSPhotoGroupModel


-(NSString *)getTitleNameWithCollectionLocalizedTitle:(NSString *)localizedTitle{
    
    NSDictionary *titleDic = @{@"Favorites":@"我的收藏",
                               @"Panoramas":@"全景",
                               @"Recents":@"最近项目",
                               @"Slo-mo":@"慢动作",
                               @"Screenshots":@"屏幕截图",
                               @"Bursts":@"连拍",
                               @"Videos":@"视频",
                               @"Selfies":@"自拍",
                               @"Hidden":@"隐藏项目",
                               @"Time-lapse":@"延时拍摄",
                               @"Recently Added":@"最近添加的",
                               @"Recently Deleted":@"最近删除",
                               @"Animated":@"动图",
                               @"Long Exposure":@"长曝光",
                               @"Portrait":@"人像",
                               @"Live Photos":@"实况图片",
                               @"Camera Roll":@"相机胶卷",
    };
    
    
    return titleDic[localizedTitle]?:localizedTitle;
    
}


@end

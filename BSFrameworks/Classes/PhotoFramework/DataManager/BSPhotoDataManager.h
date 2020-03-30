//
//  BSPhotoDataManager.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Library_Photo = 0,
    Library_Video,
    Library_Photo_Video,
} LibraryType;



@class BSPhotoGroupModel;

@interface BSPhotoDataManager : NSObject


#pragma mark - 获取所有相册：封面为缓存图片（质量低）
+(void)getAllPhotoLibraryWithCacheCoverImageGroupList:(void(^)(NSArray *groupList))groupList;



#pragma mark - 获取当前相册所有图片
+(void)getCurrentImageListFromBSPhotoGroupModel:(BSPhotoGroupModel*)groupModel imageList:(void(^)(NSArray *imageList))imageList;


@end



//
//  BSPhotoDataManager.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


typedef enum : NSUInteger {
    Library_Photo = 0,
    Library_Video,
    Library_Photo_Video,
} LibraryType;



@class BSPhotoGroupModel;

@interface BSPhotoDataManager : NSObject



-(void)stopAllCache;


#pragma mark - 获取相机胶卷的 相册对象
-(void)getPhotoLibraryGroupModel:(void(^)(BSPhotoGroupModel *groupModel))groupModel;


#pragma mark - 获取所有相册
-(void)getAllAlbumsWithType:(LibraryType)libraryType albums:(void(^)(NSArray *albums))albums;


/// 预加载缓存 图片
/// assetCollection 要加载的相册
/// targetSize 缓存图片大小
/// contenModel 图片预显示模式
-(void)startPreLoadCacheImagesWithPHAssetArray:(NSArray *)assetArray targetSize:(CGSize)targetSize contenModel:(PHImageContentMode)contentMode;


/// 停止预加载缓存 图片
/// assetCollection 要加载的相册
/// targetSize 缓存图片大小 需要和start的相同
/// contenModel 图片预显示模式 需要和start的相同
-(void)stopPreLoadCacheImagesWithPHAssetArray:(NSArray *)assetArray targetSize:(CGSize)targetSize contenModel:(PHImageContentMode)contentMode;



/// 根据 PHAsset 获取缓存图片
-(void)getImageWithPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentModel:(PHImageContentMode )contentModel imageBlock:(void(^)(UIImage *targetImage))imageBlock;



/// 根据 PHAsset 获取原始图片
-(void)getOriginImageWithPHAsset:(PHAsset *)asset imageBlock:(void(^)(UIImage *targetImage))imageBlock;



/// 根据 PHAsset 获取原始图片
-(void)getImagesWithLocalIdentifiers:(NSArray *)localIdentifiers imageType:(NSString *)imageType isOrigin:(BOOL)isOrigin targetSize:(CGSize )targetSize resultCallBack:(void(^)(NSArray *imageArr))resultArr;


@end



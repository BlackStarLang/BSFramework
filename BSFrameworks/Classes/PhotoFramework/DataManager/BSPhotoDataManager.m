//
//  BSPhotoDataManager.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import "BSPhotoDataManager.h"
#import <Photos/Photos.h>
#import "BSPhotoGroupModel.h"
#import "BSPhotoModel.h"


@implementation BSPhotoDataManager

#pragma mark - 获取所有相册：封面为缓存图片（质量低）

+(void)getAllPhotoLibraryWithCacheCoverImageGroupList:(void(^)(NSArray *groupList))groupList{
    
    //获取所有相册集
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    /**
     * 根据相册集 转换成 自己需要的 groupModel（相册对象）
     * 然后添加到数组，返回
     */
    NSMutableArray *groupListData = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHAssetCollection * assetCollection = obj;
            //构造自定义对象，进行赋值
            BSPhotoGroupModel *groupModel = [[BSPhotoGroupModel alloc]init];
            [self getModelPropertyValue:groupModel assetCollection:assetCollection dataArr:groupListData];
        }];
        
        //按数量排序
        [groupListData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BSPhotoGroupModel *model1 = obj1;
            BSPhotoGroupModel *model2 = obj2;
            if (model1.count<=model2.count) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
            
        dispatch_async(dispatch_get_main_queue(), ^{
            groupList(groupListData);
        });
    });
}



#pragma mark - 根据 PHAssetCollection 对 BSPhotoGroupModel 对象进行赋值

+(void)getModelPropertyValue:(BSPhotoGroupModel *)model assetCollection:(PHAssetCollection*)assetCollection dataArr:(NSMutableArray *)dataArr {
    
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];

    if (assetResult.count>0) {
                
        model.assetCollection = assetCollection;
        model.title = [model getTitleNameWithCollectionLocalizedTitle:assetCollection.localizedTitle];
        model.count = assetResult.count;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        
        __block UIImage *img = [[UIImage alloc]init];
        
        [manager requestImageForAsset:assetResult.lastObject targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            img = result;
        }];
        
        model.coverImage = img;
        [dataArr addObject: model];
    }
}


#pragma mark - 获取当前相册所有图片（缩略图）
+(void)getCurrentImageListFromBSPhotoGroupModel:(BSPhotoGroupModel*)groupModel libraryType:(LibraryType)libraryType imageList:(void(^)(NSArray *imageList))imageList{
    
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:groupModel.assetCollection options:nil];
    
    NSMutableArray *photosArr = [NSMutableArray array];
    
    
    __block NSInteger preCount = 40;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            
            int allCount = 0;
            
            for (PHAsset *asset in assetResult) {
                allCount ++ ;
                
                if (libraryType == Library_Photo) {
                    
                    if (asset.mediaType==PHAssetMediaTypeImage) {
                        
                        BSPhotoModel *photoModel = [[BSPhotoModel alloc]init];
                        photoModel.asset = asset;
                        photoModel.identifier = asset.localIdentifier;
                        
                        PHImageManager *manager = [PHImageManager defaultManager];
                        
                        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                        options.resizeMode = PHImageRequestOptionsResizeModeFast;
                        options.synchronous = YES;
                        
                        [manager requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            
                            photoModel.thumbImage = result;
                        }];
                        
                        [photosArr addObject:photoModel];
                        
                        if (preCount - photosArr.count == 0 || photosArr.count == allCount) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                imageList(photosArr);
                                preCount = preCount + 40;
                            });
                        }
                    }
                    
                }else if (libraryType == Library_Video){
                    
                    if (asset.mediaType==PHAssetMediaTypeVideo) {
                        
                        
                    }
                    
                    
                }else{
                    
                    if (asset.mediaType==PHAssetMediaTypeVideo||asset.mediaType==PHAssetMediaTypeImage) {
                        
                        
                    }
                }
            }
            
            [self getPhotoModelOriginImageWithPhotoModelArr:photosArr imageList:imageList];
        }
    });
}


#pragma mark - 获取当前相册所有图片（原始图片）
+(void)getPhotoModelOriginImageWithPhotoModelArr:(NSArray *)modelArr imageList:(void(^)(NSArray *imageList))imageList{
            
    for (int i = 0 ; i< modelArr.count ; i++) {
        
        BSPhotoModel *photoModel = modelArr[i];

        PHImageManager *manager = [PHImageManager defaultManager];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = NO;
        
        [manager requestImageDataForAsset:photoModel.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            photoModel.originImageSize = imageData.length/1024.0;
            photoModel.originImage = [UIImage imageWithData:imageData];
            
        }];
    }
}
                   


@end

//
//  BSPhotoGroupModel.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAssetCollection;
@class PHFetchResult;


@interface BSPhotoGroupModel : NSObject

@property (nonatomic ,strong) PHAssetCollection *assetCollection;//origin相册
@property (nonatomic ,strong) PHFetchResult *fetchResult;        //相册图片数组

@property (nonatomic ,assign ) NSInteger count;    //相册里图片个数
@property (nonatomic ,strong ) NSString *title;    //相册名称
@property (nonatomic ,strong ) UIImage *coverImage;    //相册封面图


-(NSString *)getTitleNameWithCollectionLocalizedTitle:(NSString *)localizedTitle;

@end

NS_ASSUME_NONNULL_END

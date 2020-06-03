//
//  BSPhotoViewModel.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PhotoGroupListCell;
@class PhotoListCollectionCell;
@class BSPhotoGroupModel;
@class BSPhotoModel;


@interface BSPhotoViewModel : NSObject

#pragma mark - PhotoGroupListCell 展示数据 BSPhotoGroupModel
+(void)displayGroupListCell:(PhotoGroupListCell *)cell groupModel:(BSPhotoGroupModel *)groupModel;


#pragma mark - PhotoListCollectionCell 展示数据 BSPhotoModel
+(void)displayPhotoListCollectionCell:(PhotoListCollectionCell *)cell photoModel:(BSPhotoModel *)photoModel;


@end

NS_ASSUME_NONNULL_END

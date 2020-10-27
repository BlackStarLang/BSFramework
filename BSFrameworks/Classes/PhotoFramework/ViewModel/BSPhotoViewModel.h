//
//  BSPhotoViewModel.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <Foundation/Foundation.h>



@class PhotoGroupListCell;
@class PhotoListCollectionCell;
@class BSPhotoGroupModel;
@class BSPhotoModel;
@class BSPhotoDataManager;

@interface BSPhotoViewModel : NSObject

#pragma mark - PhotoGroupListCell 展示数据 BSPhotoGroupModel
+(void)displayGroupListCell:(PhotoGroupListCell *)cell groupModel:(BSPhotoGroupModel *)groupModel dataManager:(BSPhotoDataManager *)dataManager;


#pragma mark - PhotoListCollectionCell 展示数据 BSPhotoModel
+(void)displayPhotoListCollectionCell:(PhotoListCollectionCell *)cell targetSize:(CGSize )targetSize photoModel:(BSPhotoModel *)photoModel dataManager:(BSPhotoDataManager *)dataManager;


@end



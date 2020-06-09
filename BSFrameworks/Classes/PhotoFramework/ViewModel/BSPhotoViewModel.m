//
//  BSPhotoViewModel.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import "BSPhotoViewModel.h"
#import "PhotoGroupListCell.h"
#import "BSPhotoGroupModel.h"
#import "PhotoListCollectionCell.h"
#import "BSPhotoModel.h"
#import "BSPhotoDataManager.h"

@implementation BSPhotoViewModel

#pragma mark - PhotoGroupListCell 展示数据 BSPhotoGroupModel
+(void)displayGroupListCell:(PhotoGroupListCell *)cell groupModel:(BSPhotoGroupModel *)groupModel dataManager:(BSPhotoDataManager *)dataManager{
    
    PHFetchResult *fetchResult = groupModel.fetchResult;
    
    [dataManager getImageWithPHAsset:fetchResult.lastObject targetSize:CGSizeMake(60 * [UIScreen mainScreen].scale, 60 * [UIScreen mainScreen].scale) contentModel:PHImageContentModeAspectFill imageBlock:^(UIImage *targetImage) {
        cell.thumbImgView.image = targetImage;
    }];
    
    cell.groupNameLabel.text = groupModel.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)groupModel.count];
}


#pragma mark - PhotoListCollectionCell 展示数据 BSPhotoModel
+(void)displayPhotoListCollectionCell:(PhotoListCollectionCell *)cell targetSize:(CGSize )targetSize photoModel:(BSPhotoModel *)photoModel dataManager:(BSPhotoDataManager *)dataManager{
        
    [dataManager getImageWithPHAsset:photoModel.asset targetSize:targetSize contentModel:PHImageContentModeAspectFill imageBlock:^(UIImage *targetImage) {
        if ([cell.identifier isEqualToString:photoModel.asset.localIdentifier]) {
            cell.imageView.image = targetImage;
        }
    }];
    cell.selectBtn.hidden = NO;
    cell.selectBtn.selected = photoModel.isSelect;
}



@end

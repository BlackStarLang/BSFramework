//
//  PhotoListCollectionCell.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoListCollectionCell : UICollectionViewCell

@property (nonatomic ,copy) NSString *identifier;

@property (nonatomic ,strong) UIImageView *imageView;

@property (nonatomic ,strong) UIButton *selectBtn;

@property (nonatomic ,copy) void(^selectAction)(UIButton *sender);

@property (nonatomic ,strong) UIView *bottomView;       //视频信息展示
@property (nonatomic ,strong) UIView *bottomAlphaView;  //视频信息透明度View
@property (nonatomic ,strong) UILabel *durationLabel;   //视频时长展示

@end

NS_ASSUME_NONNULL_END

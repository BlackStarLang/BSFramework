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

@end

NS_ASSUME_NONNULL_END

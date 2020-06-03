//
//  PhotoGroupListCell.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoGroupListCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *thumbImgView;

@property (nonatomic ,strong) UILabel *groupNameLabel;

@property (nonatomic ,strong) UILabel *countLabel;


@end

NS_ASSUME_NONNULL_END

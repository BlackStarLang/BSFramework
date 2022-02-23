//
//  BSRootCell.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/4.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

///====================================
/// MARK: Class 说明
/// Desc: 两个跟视图的cell
///
/// Author : BlackStar
///====================================

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSRootCell : UITableViewCell

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *indexLabel;

@end

NS_ASSUME_NONNULL_END

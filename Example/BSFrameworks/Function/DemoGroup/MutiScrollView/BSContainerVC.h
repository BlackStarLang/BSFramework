//
//  BSContainerVC.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  BSClassifyScrollView;

@interface BSContainerVC : UIViewController


/// tableview's headerView
@property (nonatomic ,strong) UIView *headerView;


/// child VC , item title isEqualToString childViewController's title
@property (nonatomic ,strong) NSArray *childViewControllers;



@property (nonatomic ,strong ,readonly) BSClassifyScrollView *classifyScrollView;

@end

NS_ASSUME_NONNULL_END

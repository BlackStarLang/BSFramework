//
//  BSClassifyScrollView.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BSClassifyScrollView : UIView


@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic ,strong) NSArray *itemsTitle;

@property (nonatomic ,copy) void(^classifyDidSelectedItem)(NSInteger selectIndex);

/// classify scrollView layout style
/// 0 left , default
/// 1 center
/// 2 right
@property (nonatomic ,assign) NSInteger style;







@end






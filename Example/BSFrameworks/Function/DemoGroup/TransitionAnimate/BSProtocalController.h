//
//  BSProtocalController.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/27.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface BSProtocalController : UIPresentationController <UIViewControllerTransitioningDelegate>

/// ================================================
/// isAlert = YES 是 alert
/// isAlert = NO  是 actionsheet
/// ================================================
@property (nonatomic ,assign) BOOL isAlert;




/// ================================================
/// isCustomStyle = YES 是自定义样式，头部视图自己添加
/// isCustomStyle = NO  是默认样式，样式和系统的
/// alertController差不多
/// ================================================
@property (nonatomic ,assign) BOOL isCustomStyle;// 是自定义样式还是默认样式




-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController title:(NSString *)title descreption:(NSString *)descreption;





@end

NS_ASSUME_NONNULL_END

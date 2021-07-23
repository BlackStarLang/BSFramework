//
//  BSBoostPresentationVC.h
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/23.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BSBoostPresentationVC : UIPresentationController<UIViewControllerTransitioningDelegate>


-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView;

@end



//
//  BSTransitionBoostAnimator.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/29.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSTransitionBoostAnimator.h"

@implementation BSTransitionBoostAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 1;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:toView];
    CGRect originFrame = toView.frame;
    
    toView.frame = CGRectZero;
    toView.center = CGPointMake(originFrame.size.width/2, originFrame.size.height/2);
    
    [UIView animateWithDuration:1 animations:^{
        toView.frame = originFrame;
    }completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}


@end

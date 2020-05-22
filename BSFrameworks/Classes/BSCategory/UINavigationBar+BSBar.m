//
//  UINavigationBar+BSBar.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import "UINavigationBar+BSBar.h"

@implementation UINavigationBar (BSBar)


#pragma mark - 设置UINavigationBar 的backgroundImage 和shadowImage

-(void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage{
    
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:shadowImage];
}



#pragma mark - 设置UINavigationBar 颜色和透明度

-(void)setBackgroundColor:(UIColor*)backgroundColor alpha:(CGFloat)alpha animate:(BOOL)animate{
    
    UINavigationBar *navigationBar = self;
    UIView *bgView = [navigationBar valueForKey:@"_backgroundView"];
    bgView.backgroundColor = backgroundColor;
    
    if (animate) {
        [UIView animateWithDuration:0.1 animations:^{
            bgView.alpha = alpha;
        }];
    }else{
        bgView.alpha = alpha;
    }
    
}


@end

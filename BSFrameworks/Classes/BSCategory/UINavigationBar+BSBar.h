//
//  UINavigationBar+BSBar.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import <UIKit/UIKit.h>



@interface UINavigationBar (BSBar)

#pragma mark - 设置UINavigationBar 的backgroundImage 和 shadowImage(navi的分割线)

-(void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage;

#pragma mark - 设置UINavigationBar 颜色和透明度
//若需要alpha生效 则许调用 setNavigationBarBackgroundImage:[UIImage new]] shadowImage:[UIImage new]

-(void)setBackgroundColor:(UIColor*)backgroundColor alpha:(CGFloat)alpha animate:(BOOL)animate;


@end



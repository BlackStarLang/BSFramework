//
//  UIView+BSView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCALE_W(x) (SCREEN_WIDTH/375.0 * x)

//是否全面屏包括X XS XSMax XR
#define iPhoneX (SCREEN_HEIGHT==812||SCREEN_HEIGHT==896)

//适配iPhoneX
#define STATUSBAR_HEIGHT      (iPhoneX ? 44.f : 20.f)   //状态栏

#define STATUSNAVIBAR_HEIGHT  (iPhoneX ? 88.f : 64.f)   //状态栏 + 导航栏

#define TABBAR_HEIGHT         (iPhoneX ? (49.f+34.f) : 49.f)    //Tabbar

#define BOTTOM_SAFE_MARGIN    (iPhoneX ? 34.f : 0.f)    //安全域底部的高度


@interface UIView (BSView)

@property (nonatomic ,assign) CGFloat top;
@property (nonatomic ,assign) CGFloat left;
@property (nonatomic ,assign) CGFloat right;
@property (nonatomic ,assign) CGFloat bottom;
@property (nonatomic ,assign) CGFloat width;
@property (nonatomic ,assign) CGFloat height;
@property (nonatomic ,assign) CGFloat centerX;
@property (nonatomic ,assign) CGFloat centerY;


@end

NS_ASSUME_NONNULL_END

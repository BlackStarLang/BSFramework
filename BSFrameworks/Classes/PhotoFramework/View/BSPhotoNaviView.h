//
//  BSPhotoNaviView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSPhotoNaviView : UIView

@property (nonatomic ,  copy) NSString *title;
@property (nonatomic ,strong) UIColor *titleColor;

@property (nonatomic ,assign) BOOL hiddenRightBtn;
@property (nonatomic ,assign) BOOL hiddenLeftBtn;

-(void)setLeftBtnTitle:(NSString *)leftTitle titleColor:(UIColor *)titleColor;

-(void)setRightBtnTitle:(NSString *)rightTitle titleColor:(UIColor *)titleColor;

-(void)setRightBtnImage:(NSString *)imageName;

@property (nonatomic ,copy) void(^naviAction)(BOOL isBack);

@end

NS_ASSUME_NONNULL_END

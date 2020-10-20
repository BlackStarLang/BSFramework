//
//  BSVideoBottomView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/20.
//

#import <UIKit/UIKit.h>
#import "BSPhotoTypeSelectView.h"

#pragma mark 枚举 -- 按钮类型
typedef enum : NSUInteger {
    
    FUNC_TYPE_PIC_RECORDED = 0,  // 点击拍照
    FUNC_TYPE_VIDEO_RECORDING,   // 点击录制
    FUNC_TYPE_VIDEO_RECORDED,    // 录制完成
    
    FUNC_TYPE_RETRY,        // 点击重新拍照
    FUNC_TYPE_BACK,         // 点击返回（退出）
    FUNC_TYPE_NEXT,         // 点击下一步
    
} FUNCTYPE;


@class BSVideoBottomView;
@class BSVideoTakeBtn;

#pragma mark - 点击事件回调
@protocol BSVideoBottomViewDelegate <NSObject>

@optional

#pragma mark 切换拍照、视频选项
-(void)BSVideoBottomView:(BSVideoBottomView *)bottomView didSelectType:(SELECTTYPE)selectType;

#pragma mark 点击任一按钮的回调，根据 FUNCTYPE 识别点击的按钮
-(void)BSVideoBottomView:(BSVideoBottomView *)bottomView didClickFuncBtnWithType:(FUNCTYPE)funcType;

@end


@interface BSVideoBottomView : UIView

@property (nonatomic ,strong) BSVideoTakeBtn *takeBtn;//拍照按钮
@property (nonatomic ,strong) UIView *alphaView;    // 用来控制透明度的背景

@property (nonatomic ,strong) UIButton *cancelBtn;  //取消、重新拍摄按钮
@property (nonatomic ,strong) UIButton *nextBtn;    // 下一步按钮

@property (nonatomic ,strong) BSPhotoTypeSelectView *typeSelView;

@property (nonatomic ,weak) id <BSVideoBottomViewDelegate> delegate;

@property (nonatomic ,assign) SELECTTYPE selectType;

@end



#pragma mark - 封装拍照按钮
@interface BSVideoTakeBtn : UIView

@property (nonatomic ,strong) UIButton *takeBtn;
@property (nonatomic ,strong) CALayer *circleLayer;

@property (nonatomic ,assign,getter=isSelected) BOOL selected;

-(void)addMyTarget:(NSObject *)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

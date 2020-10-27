//
//  BSPhotoPreviewVideoVC.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/23.
//

#import <UIKit/UIKit.h>
#import "BSPhotoProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSPhotoPreviewVideoVC : UIViewController


/// ====================================
/// navi tintColor
/// ====================================
@property (nonatomic ,strong) UIColor *mainColor;


/// ====================================
/// 状态栏样式
/// ====================================
@property (nonatomic ,assign) UIStatusBarStyle barStyle;


/// ====================================
/// 预览图片时，navibar 的 alpha 值
/// navibar alpha,默认为 1
/// naviBarAlpha <=0 时，按1处理
/// ====================================
@property (nonatomic ,assign) CGFloat preNaviAlpha;


/// ====================================
/// 页面是 present 还是 pop
/// ====================================
@property (nonatomic ,assign ) BOOL isPresent;


/// ====================================
/// 预览信息：只读
/// ====================================
@property (nonatomic ,strong ,readonly) NSMutableArray *previewVideos;//要预览的视频数组
@property (nonatomic ,assign ,readonly) NSInteger currentIndex;       //当前下标



#pragma mark  - 相机独立使用时
//=============== 我是分割线 ===============
//=============== 我是分割线 ===============

/// ====================================
/// 如果仅仅使用预览类，则不需要使用下列属性
/// 下列属性为图片选择器内部使用
/// 即 BSPhotoListController 使用
/// ====================================

/// 图片选择器的预览还是 普通预览，默认NO
@property (nonatomic ,assign ) BOOL selectPreview;


/// ====================================
/// 设置 要预览的图片源 previewVideos
/// defaultIndex默认下标
/// ====================================
-(void)setPreviewVideos:(NSMutableArray *)previewVideos defaultIndex:(NSInteger)defaultIndex;


@end

NS_ASSUME_NONNULL_END

//
//  BSPhotoPreviewVideoVC.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/23.
//

#import <UIKit/UIKit.h>
#import "BSPhotoProtocal.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 支持预览的三种类型：
 * url
 * path
 * avasset
 */
typedef enum : NSUInteger {
    VIDEOTYPE_URL = 0,    //网络链接url(非URL)
    VIDEOTYPE_PATH,       //本地路径 预览
    VIDEOTYPE_AVASSET,    //系统AVASSET对象预览
    VIDEOTYPE_PHOTO,      //BSPhotoModel 预览(组件内对象)
} VIDEOTYPE;

@interface BSPhotoPreviewVideoVC : UIViewController

/// selectPreview = YES 时，为相册的预览（带有选中图片、原图等功能
/// 否则为普通预览，仅仅用来预览图片使用
@property (nonatomic ,assign ) BOOL selectPreview;


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
/// 预览信息：只读
/// ====================================
@property (nonatomic ,strong ,readonly) NSMutableArray *previewVideos;//要预览的视频数组
@property (nonatomic ,assign ,readonly) NSInteger currentIndex;       //当前下标
@property (nonatomic ,assign ,readonly) VIDEOTYPE videoType; // 预览的视频类型



#pragma mark  - 相机独立使用时
//=============== 我是分割线 ===============
//=============== 我是分割线 ===============

/// ====================================
/// 如果仅仅使用预览类，则不需要使用下列属性
/// 下列属性为图片选择器内部使用
/// 即 BSPhotoListController 使用
/// ====================================


/// ====================================
/// 设置 要预览的图片源 previewVideos
/// defaultIndex默认下标
/// 仅支持 AVAsset 类型
/// ====================================
-(void)setPreviewVideos:(NSMutableArray *)previewVideos defaultIndex:(NSInteger)defaultIndex videoType:(VIDEOTYPE)videoType;


@end

NS_ASSUME_NONNULL_END

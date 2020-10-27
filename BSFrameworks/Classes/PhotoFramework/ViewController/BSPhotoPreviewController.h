//
//  BSPhotoPreviewController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * 支持预览的三种类型：
 * url
 * path
 * image
 */
typedef enum : NSUInteger {
    PREVIEWTYPE_URL = 0,    //url 预览
    PREVIEWTYPE_PATH,       //本地路径 预览
    PREVIEWTYPE_IMAGE,      //image 预览  如果是大量IMAGE 会导致内存飙升，只适合少量实例图片预览
    PREVIEWTYPE_PHOTO,      //BSPhotoModel 预览(组件内图片对象)
} PREVIEWTYPE;


@interface BSPhotoPreviewController : UIViewController


/// selectPreview = YES 时，为相册的预览（带有选中图片、原图等功能
/// 否则为普通预览，仅仅用来预览图片使用
@property (nonatomic ,assign ) BOOL selectPreview;

/// ====================================
/// navi tintColor
/// ====================================
@property (nonatomic ,strong) UIColor *mainColor;


/// ====================================
/// 预览图片时，navibar 的 alpha 值
/// navibar alpha,默认为 1
/// naviBarAlpha <=0 时，按1处理
/// ====================================
@property (nonatomic ,assign) CGFloat preNaviAlpha;


/// ====================================
/// 状态栏样式
/// ====================================
@property (nonatomic ,assign) UIStatusBarStyle barStyle;


/// ====================================
/// 预览信息：只读
/// ====================================
@property (nonatomic ,strong ,readonly) NSMutableArray *previewPhotos;//要预览的图片数组
@property (nonatomic ,assign ,readonly) NSInteger currentIndex;       //当前预览的图片
@property (nonatomic ,assign ,readonly) PREVIEWTYPE previewType;      //当前预览的图片类型


/// ====================================
/// 设置 要预览的图片源 previewPhotos
/// previewType 预览图片源的类型
/// defaultIndex默认下标
/// ====================================
-(void)setPreviewPhotos:(NSMutableArray *)previewPhotos previewType:(PREVIEWTYPE)previewType defaultIndex:(NSInteger)defaultIndex;




#pragma mark -
/// ====================================
/// 如果仅仅使用预览类，则不需要使用下列属性
/// 下列属性为图片选择器内部使用
/// 即 BSPhotoListController 使用
/// ====================================

/// 已经选择的图片数组
@property (nonatomic ,strong) NSMutableArray *selectDataArr;

/// 允许选择最大个数
@property (nonatomic ,assign) NSInteger allowSelectMaxCount;

/// 当前选择了多少个
@property (nonatomic ,assign) NSInteger currentSelectedCount;

/// 是否选择原图
@property (nonatomic ,assign) BOOL isOrigin;


@property (nonatomic ,copy) void(^selectOriginImg)(BOOL isOrigin);


@end

NS_ASSUME_NONNULL_END

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



/// ====================================
/// navi tintColor
/// ====================================
@property (nonatomic ,strong) UIColor *mainColor;



/// ====================================
/// 状态栏样式
/// ====================================
@property (nonatomic ,assign) UIStatusBarStyle barStyle;



/// ====================================
/// 页面是 present 还是 pop
/// ====================================
@property (nonatomic ,assign ) BOOL isPresent;



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





/// ====================================
/// 以下为 选择图片控件需要，普通预览不需要
/// ====================================
@property (nonatomic ,assign ) BOOL selectPreview;  //选择的预览还是 普通预览，默认NO
@property (nonatomic ,strong) NSMutableArray *selectDataArr;

@property (nonatomic ,assign) NSInteger allowSelectMaxCount;
@property (nonatomic ,assign) NSInteger currentSelectedCount;




@end

NS_ASSUME_NONNULL_END

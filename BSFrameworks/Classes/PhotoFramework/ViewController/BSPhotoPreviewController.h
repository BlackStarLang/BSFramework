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
    PREVIEWTYPE_IMAGE,      //image 预览
    PREVIEWTYPE_PHOTO,      //BSPhotoModel 预览(组件内图片对象)
} PREVIEWTYPE;


@interface BSPhotoPreviewController : UIViewController

@property (nonatomic ,strong ,readonly) NSMutableArray *previewPhotos;//要预览的图片数组
@property (nonatomic ,assign ,readonly) NSInteger currentIndex;       //当前预览的图片
@property (nonatomic ,assign ,readonly) PREVIEWTYPE previewType;      //当前预览的图片类型

@property (nonatomic ,assign ) BOOL isPresent;  //是push还是 present

-(void)setPreviewPhotos:(NSArray *)previewPhotos previewType:(PREVIEWTYPE)previewType defaultIndex:(NSInteger)defaultIndex;


@end

NS_ASSUME_NONNULL_END

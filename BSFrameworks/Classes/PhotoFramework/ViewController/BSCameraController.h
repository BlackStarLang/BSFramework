//
//  BSCameraController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/4/2.
//

#import <UIKit/UIKit.h>
#import "BSPhotoProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSCameraController : UIViewController

@property (nonatomic ,weak) id<BSPhotoProtocal> delegate;


/// 照片添加水印视图（不支持视频）
@property (nonatomic ,strong) UIView *waterMarkView;


/// 是否存储到相册（不支持视频，视频默认为存储）
@property (nonatomic ,assign) BOOL saveToAlbum;


/// 媒体类型
/// 0：仅拍照
/// 1：仅录像
/// 2：可选择 拍照还是录像 （默认）
/// 备注：mediaType=2时，仅支持单独使用相机时类型选择，
/// 不支持相册控件，使用相册时：mediaType=2按照图片处理
@property (nonatomic ,assign) NSInteger mediaType;


/// 如果是 视频，限制最大录制秒数，不设置或设置0为不限制
@property (nonatomic ,assign) NSInteger maxSecond;


@end

NS_ASSUME_NONNULL_END

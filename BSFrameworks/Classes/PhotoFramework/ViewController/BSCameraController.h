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

//照片添加水印视图（不支持视频）
@property (nonatomic ,strong) UIView *waterMarkView;

@property (nonatomic ,weak) id<BSPhotoProtocal> delegate;

//是否存储到相册（不支持视频，视频默认为存储）
@property (nonatomic ,assign) BOOL saveToAlbum;


@end

NS_ASSUME_NONNULL_END

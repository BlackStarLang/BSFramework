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

@property (nonatomic ,strong) UIView *waterMarkView;//水印 视图

@property (nonatomic ,weak) id<BSPhotoProtocal> delegate;


@property (nonatomic ,assign) BOOL saveToAlbum;//是否存储到相册

@end

NS_ASSUME_NONNULL_END

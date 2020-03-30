//
//  BSPhotoPreviewController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSPhotoPreviewController : UIViewController

@property (nonatomic ,strong) NSMutableArray *previewPhotos;//要预览的图片数组
@property (nonatomic ,assign) NSInteger currentIndex;       //当前预览的图片


@end

NS_ASSUME_NONNULL_END

//
//  BSPhotoGroupController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSPhotoGroupController : UIViewController

@property (nonatomic ,strong) NSMutableArray *selectDataArr;

@property (nonatomic ,assign) BOOL autoPush;//自动跳转到第一个相册图片列表 default is YES

@property (nonatomic ,strong) UIColor *mainColor;

@end

NS_ASSUME_NONNULL_END

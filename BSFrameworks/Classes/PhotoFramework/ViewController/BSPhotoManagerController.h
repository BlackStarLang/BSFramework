//
//  BSPhotoManagerController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import <UIKit/UIKit.h>
#import "BSPhotoProtocal.h"


@interface BSPhotoManagerController : UINavigationController


@property (nonatomic ,weak) id<BSPhotoProtocal> BSDelegate;



#pragma mark - 数据相关


/// =============================================
/// 是否自动跳转到照片列表  必须设置
/// =============================================

@property (nonatomic ,assign) BOOL autoPush;



/// =============================================
/// 允许最大选择个数
/// =============================================

@property (nonatomic ,assign) NSInteger allowSelectMaxCount;



/// =============================================
/// 当前已选择图片个数
/// =============================================

@property (nonatomic ,assign) NSInteger currentSelectedCount;


/// =============================================
/// 类型 暂时只支持 Image,不支持 视频等
/// =============================================
//@property (nonatomic ,assign) NSInteger imageType;



/// =============================================
/// 主题色
/// 更改 navigation 和 toolbar 颜色
/// =============================================
@property (nonatomic ,strong) UIColor *mainColor;



/// =============================================
/// 是否支持 相机
/// 默认 YES
/// =============================================
@property (nonatomic ,assign) BOOL supCamera;



/// =============================================
/// 若 supCamera == YES
/// 是否存储到照片到相册
/// 默认 YES
/// =============================================
@property (nonatomic ,assign) BOOL saveToAlbum;




@end


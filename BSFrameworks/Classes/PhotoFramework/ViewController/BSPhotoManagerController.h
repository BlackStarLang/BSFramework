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


/// ====================================
/// preBarAlpha 为预览时，navibar的透明度
/// preBarAlpha alpha ,默认为 1
/// preBarAlpha <=0 时 ,按1处理
/// ====================================
@property (nonatomic ,assign) CGFloat preBarAlpha;


/// =============================================
/// 是否支持 相机
/// 默认 YES
/// =============================================
@property (nonatomic ,assign) BOOL supCamera;



/// =============================================
/// supCamera == YES 时，此属性生效
/// 是否存储到照片到相册(相机拍照后，点击下一步，即认为用户需要使用此照片才做存储)
/// 默认 YES
/// =============================================

/*
 PS:
 如果 saveToAlbum = NO ,拍照后点击下一步，
 会直接退出选择图片选择界面，然后代理回调当前已选图片+拍照图片
 如果 saveToAlbum = YES，拍照后点击下一步，
 会回到列表页面，拍照的图片状态为勾选状态
 */
@property (nonatomic ,assign) BOOL saveToAlbum;




@end


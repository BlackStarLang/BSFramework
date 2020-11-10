//
//  BSPhotoProtocal.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/4/3.
//

#import <Foundation/Foundation.h>

@class AVAsset;

@protocol BSPhotoProtocal <NSObject>

@optional

//******************************************//
//**************** 相册协议 *****************//
//******************************************//

#pragma mark - 相册相关

/// ===================================
/// 点击完成按钮，回调图片
/// images 是 UIImage 对象数组
/// ===================================

-(void)BSPhotoManagerDidFinishedSelectImage:(NSArray <UIImage *>*)images;




/// ===================================
/// 点击完成按钮，回调图片
/// images 是 NSData 对象数组
/// ===================================

-(void)BSPhotoManagerDidFinishedSelectImageData:(NSArray <NSData *>*)imageDataArr;



/// ===================================
/// 相机拍摄后使用视频的回调
/// 仅支持回调AVAsset
/// ===================================
-(void)BSPhotoCameraDidFinishedSelectVideoWithAVAsset:(AVAsset*)avAsset;


/// ===================================
/// 相册选择视频后的回调
/// 仅支持回调AVAsset
/// ===================================
-(void)BSPhotoManagerDidFinishedSelectVideoWithAVAsset:(AVAsset*)avAsset;


//******************************************//
//**************** 相机协议 *****************//
//********** 仅支持单独使用相机时回调 **********//
//******************************************//

#pragma mark - 相机相关


/// ===================================
/// 拍照功能
/// 点击拍照按钮
/// 单独使用相机类时可以使用
/// ===================================

/// **仅支持单独使用相机时回调**
-(void)photoCameraTakeBtnClicked;


/// ===================================
/// 拍照功能
/// 仅支持单独使用相机时回调，如果使用了整个相册控件，请使用相册代理：
/// BSPhotoManagerDidFinishedSelectImage 或
/// BSPhotoManagerDidFinishedSelectImageData
/// ===================================

/// **仅支持单独使用相机时回调**
-(void)photoCameraNextBtnClickedWithImage:(UIImage*)image;



/// ===================================
/// 视频功能
/// 获取视频回调
/// 仅支持获取视频存放地址
///
/// ***
/// 如果视频地址要做缓存，由于拼接的路径是沙盒路径，可能会随运行改变，
/// 这时缓存的路径就是错误的，需要将 Documents 前的路径使用 NSHomeDirectory()
/// 重新获取，在拼接上后边的绝对路径即可拿到真正的资源
/// ***
///
/// ===================================

/// **仅支持单独使用相机时回调**
-(void)photoCameraNextBtnClickedWithVideoPath:(NSString*)videoPath;



@end




//
//  BSPhotoProtocal.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/4/3.
//

#import <Foundation/Foundation.h>


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
-(void)BSPhotoCameraDidFinishedSelectVideoWithVideoPath:(NSString*)videoPath;




//******************************************//
//**************** 相机协议 *****************//
//********** 仅支持单独使用相机时回调 **********//
//******************************************//

#pragma mark - 相机相关


/// ===================================
/// 点击拍照按钮
/// 单独使用相机类时可以使用
/// ===================================

/// 仅支持单独使用相机时回调
-(void)photoCameraTakeBtnClicked;


/// ===================================
/// 系统内部使用，非外部回调，外部回调请使用如下代理：
/// BSPhotoManagerDidFinishedSelectImage 或
/// BSPhotoManagerDidFinishedSelectImageData
/// ===================================

/// 仅支持单独使用相机时回调
-(void)photoCameraNextBtnClickedWithImage:(UIImage*)image;



/// ===================================
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

/// 仅支持单独使用相机时回调
-(void)photoCameraNextBtnClickedWithVideoPath:(NSString*)videoPath;


@end




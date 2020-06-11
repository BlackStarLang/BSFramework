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




//******************************************//
//**************** 相机协议 *****************//
//******************************************//

#pragma mark - 相机相关


/// ===================================
/// 点击拍照按钮
/// ===================================

-(void)photoCameraTakeBtnClicked;


/// ===================================
/// 点击下一步 使用照片
/// ===================================
-(void)photoCameraNextBtnClickedWithImage:(UIImage*)image;




@end




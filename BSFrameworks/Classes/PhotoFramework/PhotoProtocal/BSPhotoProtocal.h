//
//  BSPhotoProtocal.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/4/3.
//

#import <Foundation/Foundation.h>


@protocol BSPhotoProtocal <NSObject>

#pragma mark - 点击拍照按钮
-(void)photoCameraTakeBtnClicked;

#pragma mark - 点击下一步 使用照片
-(void)photoCameraNextBtnClickedWithImage:(UIImage*)image;



@end




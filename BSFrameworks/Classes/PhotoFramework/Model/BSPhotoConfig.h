//
//  BSPhotoConfig.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/6/10.
//

#import <Foundation/Foundation.h>



@interface BSPhotoConfig : NSObject

+(instancetype)shareConfig;


/// =============================================
/// 允许最大选择个数
/// 默认 9 
/// =============================================

@property (nonatomic ,assign) NSInteger allowSelectMaxCount;



/// =============================================
/// 当前已选择图片个数
/// =============================================

@property (nonatomic ,assign) NSInteger currentSelectedCount;


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



/// =============================================
/// 是否原图
/// =============================================
@property (nonatomic ,assign ) BOOL isOrigin;


/// =============================================
/// 颜色
/// =============================================
@property (nonatomic ,strong ) UIColor *mainColor;


/// 重置所有属性值
-(void)resetAllConfig;

@end



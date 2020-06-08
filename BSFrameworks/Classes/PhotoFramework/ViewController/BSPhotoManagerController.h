//
//  BSPhotoManagerController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import <UIKit/UIKit.h>



@interface BSPhotoManagerController : UINavigationController



#pragma mark - 数据相关
/// 是否自动跳转到照片列表  必须设置
@property (nonatomic ,assign) BOOL autoPush;


/// 允许最大选择个数
@property (nonatomic ,assign) NSInteger allowSelectMaxCount;


/// 类型
@property (nonatomic ,assign) NSInteger imageType;


/// 允许最大选择个数
//@property (nonatomic ,assign) NSInteger allowSelectMaxCount;



@end


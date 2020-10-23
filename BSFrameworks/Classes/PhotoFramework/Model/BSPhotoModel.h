//
//  BSPhotoModel.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSPhotoModel : NSObject

@property (nonatomic ,strong) PHAsset *asset ;          //原始数据
@property (nonatomic ,  copy) NSString *identifier ;    //唯一标识
@property (nonatomic ,  copy) NSString *suffix ;        //后缀( .png  .jpeg  ..)
@property (nonatomic ,assign) CGFloat originImageSize ; //原图大小（MB）

@property (nonatomic ,assign) BOOL isSelect ;   //图片是否被选中
@property (nonatomic ,assign) BOOL needOrigin ; //是否需要原图
@property (nonatomic ,assign) BOOL isVideo ;    //是否是 视频

@property (nonatomic ,assign) NSTimeInterval duration ; //视频时长
@property (nonatomic ,copy) NSString * durationStr;     //视频时长


@end

NS_ASSUME_NONNULL_END

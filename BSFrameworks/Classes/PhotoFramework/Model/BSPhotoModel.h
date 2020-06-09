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


@end

NS_ASSUME_NONNULL_END

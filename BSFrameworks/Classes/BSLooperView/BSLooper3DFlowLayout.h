//
//  BSLooper3DFlowLayout.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BSLOOP_STYLE_NORMAL = 0,// 默认 3D轮播
    BSLOOP_STYLE_CARD, // 卡片样式(类似于卡包样式的叠加覆盖效果)
} BSLOOP_STYLE;


@interface BSLooper3DFlowLayout : UICollectionViewFlowLayout

///=================================
///宽高缩放比例
///=================================
@property (nonatomic ,assign) CGFloat scale;



///=================================
///两边item的中心点偏移量
///默认 centerOffset = 0
///=================================
@property (nonatomic ,assign) CGFloat centerOffset;



///=================================
///样式：
///default is normal : 常见的3D轮播图.
///card : 卡片重叠 样式
///=================================
@property (nonatomic ,assign) BSLOOP_STYLE loopStyle;




///=================================
/// 设置可见个数(不支持 minimumLineSpacing)
/// 会根据可见个数和itemSize、collectionViewSize
/// 自动排版（均分）
/// 如：item宽度260 ，collectionView 宽度 300
/// 可见cell个数为 4个，那么cell间间距就是 (300-260)/4 = 10
///=================================
@property (nonatomic ,assign) NSInteger visibleCount;


///=================================
/// 防闪退处理，记录collectionView的最大row
///=================================
@property (nonatomic ,assign) NSInteger maxIndexRow;


/// 暂时不做
/////=================================
///// size 最小缩放倍数
///// 默认 miniScale = 0.5
/////=================================
//@property (nonatomic ,assign) CGFloat miniScale;
//
//
/////=================================
///// size 最大缩放倍数
///// 默认 maxScale = 1
/////=================================
//@property (nonatomic ,assign) CGFloat maxScale;


/////=================================
///// 暂未完成
///// 仅支持 BSLOOP_STYLE_NORMAL 模式
///// 仅缩放一次 即：除了当前item的相邻item，其他不进行二次缩放
///// 大概样式如下
/////       |--|
///// |——|——|  |——|——|
///// |  |  |  |  |  |
/////=================================
//@property (nonatomic ,assign) BOOL onceScale;




@end

NS_ASSUME_NONNULL_END

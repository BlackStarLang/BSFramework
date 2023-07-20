//
//  BSLooperView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/22.
//

#import <UIKit/UIKit.h>
#import "BSLooper3DFlowLayout.h"

@class BSLooperView;

/* ********************************************************* */
/* 无限轮播 BSLooperView 代理 回调                              */
/* ********************************************************* */

#pragma mark - BSLooperView 代理
@protocol BSLooperViewDelegate <NSObject>

@required

/// ====================================
/// BSLooperView cellForRow 回调
/// ====================================

-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell cellForModel:(id)model;


@optional

/// ====================================
/// BSLooperView cell 点击
/// ====================================

-(void)BSLooperView:(BSLooperView *)looperView didSelectModel:(id)model;



@end


/* ********************************************************* */
/* 无限轮播原理:将目标数组添加到 轮播数组中，添加三次                */
/* 构造成所需数据样式,exampl:                                   */
/* 目标数组 A=[1,2,3], 构造新数组 newA=[1,2,3, 1,2,3, 1,2,3]    */
/* 让当前pageIndex 始终处于 中间的1，2，3下，即pageIndex=3、4、5   */
/* 当pageIndex=2是,设置collectionview的scrollToItemAtIndexPath */
/* 的row=5,然后重置pageIndex=5                                 */
/* ********************************************************* */

/// ※ ※ ※ 不支持多分组，即不支持section>1 ※ ※ ※

#pragma mark -

typedef NS_OPTIONS(NSInteger, BSLooperPosition){
    
    //只针对scrollDirection = ScrollDirectionHorizontal的
    BSLooperPositionLeft    =   0,      /// 向左
    BSLooperPositionRight   =   1,      /// 向右
    
    //只针对scrollDirection = ScrollDirectionVertical的
    BSLooperPositionUp      =   2,      /// 向上
    BSLooperPositionDown    =   3       /// 向下
};


@interface BSLooperView : UIView

#pragma mark - property 自定义属性

@property (nonatomic ,weak) id <BSLooperViewDelegate> delegate;


///=================================
///样式：
///default is normal ：常见的3D轮播图 。
///Card ：卡片重叠样式
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



/// ====================================
/// 是否无限轮播
/// ====================================
@property (nonatomic ,assign) BOOL isInfinite;



/// ====================================
///  if isInfinite = NO , autoLoop unavailable
///  如果没有开启无线轮播，此属性将无效
///  是否自动轮播
/// ====================================
@property (nonatomic ,assign) BOOL autoLoop;


/// ====================================
///  是否加入到runloop的common mode 中
///  默认不加入
/// ====================================
@property (nonatomic ,assign) BOOL joinRunLoopCommonMode;


/// ====================================
/// 如果 autoLoop=YES
/// 可设置 轮播滚动时间间隔，单位（s），默认 3(s)
/// 如果 duration < 0.5 ，duration = 3
/// ====================================
@property (nonatomic ,assign) NSTimeInterval duration;



/// =========================================
/// 默认横向滚动 UICollectionViewScrollDirectionHorizontal
/// 只针对内置布局，对自定义 UICollectionViewLayout 无效
/// =========================================
@property (nonatomic ,assign) UICollectionViewScrollDirection scrollDirection;



/// =========================================
/// 横向默认 BSLooperPositionLeft（从左向右滚动）
/// 纵向默认 BSLooperPositionUp  （从下向上滚动）
/// 只针对内置布局，对自定义 UICollectionViewLayout 无效
/// =========================================
@property (nonatomic ,assign) BSLooperPosition looperPosition;



/// ====================================
/// 设置自定义cell的名称，会自动注册cell
/// ====================================
@property (nonatomic ,copy) NSString *cellName;



/// ====================================
/// 设置item size
/// default self.bounds.size
/// ====================================
@property (nonatomic ,assign) CGSize itemSize;



/// ====================================
/// 设置 sectionInset
/// default UIEdgeInsetsZero
/// ====================================
@property (nonatomic ,assign) UIEdgeInsets sectionInset;


/// ====================================
/// 仅支持 loopStype == NORMAL
/// 设置 minimumLineSpacing
/// 最小行间距：default 0
/// ====================================
@property (nonatomic ,assign) CGFloat minimumLineSpacing;


/// ====================================
/// 设置 minimumInteritemSpacing
/// 最小列（纵）间距：default 0
/// 因为不支持多列，所以没用
/// ====================================
//@property (nonatomic ,assign) CGFloat minimumInteritemSpacing;


///=================================
///仅支持 loopStype == NORMAL
///两边item的中心点偏移量
///如果横向，则是中心点上下偏移，否则左右偏移
///默认 centerOffset = 0
///=================================
@property (nonatomic ,assign) CGFloat centerOffset;



/// ====================================
/// 设置 缩放比例
/// 默认不缩放 scale = 1
/// ====================================
@property (nonatomic ,assign) CGFloat scale;



/// ==============================================
/// 轮播图 数组:所有属性 需在 dataArr 设置前 赋值，之后无效
/// 数组内数据可为任意类型，
/// BSLooperViewDelegate 会输出目标对象dataArr[indexPath.row]
/// ==============================================
@property (nonatomic ,strong) NSArray <id>*dataArr;




#pragma mark - method

/// ==============================================
/// 可通过此方法，自定义 UICollectionViewLayout
/// 暂不支持，后续版本增加
/// ==============================================
//-(void)setCollectionViewLayout:(UICollectionViewLayout *)layout;





@end




/* ********************************************************* */
/* 如果 BSLooperView 开启了自动轮播                             */
/* 则通过 weak 弱化引用关系,                                    */
/* 再利用runtime消息转发机制，调用 BSLooperView 的timer 方法      */
/* ********************************************************* */

#pragma mark - 
@interface TimerTarget : NSObject


@property (nonatomic ,weak) BSLooperView * target;


@end

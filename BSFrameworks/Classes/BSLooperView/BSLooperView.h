//
//  BSLooperView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/22.
//

#import <UIKit/UIKit.h>


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
/* 构造成所叙述句样式,exampl:                                   */
/* 目标数组 A=[1,2,3], 构造新数组 newA=[1,2,3, 1,2,3, 1,2,3]    */
/* 让当前pageIndex 始终处于 中间的1，2，3下，即pageIndex=3、4、5   */
/* 当pageIndex=2是,设置collectionview的scrollToItemAtIndexPath */
/* 的row=5,然后重置pageIndex=5                                 */
/* ********************************************************* */

/// *** 只支持一行或一列 ***

#pragma mark -

typedef NS_OPTIONS(NSInteger, BSLooperPosition){
    
    //只针对scrollDirection = ScrollDirectionHorizontal的
    BSLooperPositionLeft    =   0,      /// 向左
    BSLooperPositionRight   =   1<<0,   /// 向右
    
    //只针对scrollDirection = ScrollDirectionVertical的
    BSLooperPositionUp      =   2<<1,   /// 向上
    BSLooperPositionDown    =   3<<2    /// 向下
};


@interface BSLooperView : UIView

#pragma mark - property 自定义属性

@property (nonatomic ,weak) id <BSLooperViewDelegate> delegate;


/// ====================================
/// 是否无限轮播
/// ====================================
@property (nonatomic ,assign) BOOL isInfinite;



/// ====================================
///  是否自动轮播(只有无限轮播，才可自动轮播)
/// ====================================
@property (nonatomic ,assign) BOOL AUTO;



/// ====================================
/// 如果 AUTO=YES
/// 可设置 轮播滚动时间间隔，单位（s），默认 3(s)
/// 如果 timeLength < 0.5 ，timeLength = 3
/// ====================================
@property (nonatomic ,assign) NSTimeInterval timeLength;



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
/// 设置 minimumLineSpacing
/// 最小行间距：default 0
/// ====================================
@property (nonatomic ,assign) CGFloat minimumLineSpacing;


/// ====================================
/// 设置 minimumInteritemSpacing
/// 最小列（纵）间距：default 0
/// ====================================
@property (nonatomic ,assign) CGFloat minimumInteritemSpacing;


///=================================
///两边item的中心点偏移量
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

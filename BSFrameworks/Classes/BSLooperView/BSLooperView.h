//
//  BSLooperView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/22.
//

#import <UIKit/UIKit.h>


@class BSLooperView;


#pragma mark - BSLooperView 代理
@protocol BSLooperViewDelegate <NSObject>

@required

/// BSLooperView cellForRow 回调
-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell cellForModel:(id)model;


@optional

/// cell 点击
-(void)BSLooperView:(BSLooperView *)looperView didSelectModel:(id)model;



@end


/* ********************************************************* */
/* 无限轮播原理:将目标数组添加到 轮播数组中，添加三次                */
/* 构造成所叙述句样式,exampl:                                   */
/* 目标数组 A=[1,2,3], 构造新数组 newA=[1,2,3, 1,2,3, 1,2,3]    */
/* 让当前pageIndex 始终处于 中间的1，2，3下，即pageIndex=3、4、5   */
/* 当pageIndex=2是,设置collectionview的scrollToItemAtIndexPath */
/* 的row=5,然后重置pageIndex=5                                 */
/* ************************************************** */

/// *** 所有属性 需在 dataArr 设置前 赋值，之后无效 ***

#pragma mark -
@interface BSLooperView : UIView

#pragma mark - property 自定义属性

@property (nonatomic ,weak) id <BSLooperViewDelegate> delegate;


///是否无限轮播
@property (nonatomic ,assign) BOOL isCircle;


///是否自动轮播(只有无限轮播，才可自动轮播) 
@property (nonatomic ,assign) BOOL AUTO;


///如果 AUTO=YES 可设置 轮播滚动时间间隔，单位（s），默认 3(s)
///如果 timeLength < 0.5 ，timeLength = 3
@property (nonatomic ,assign) NSTimeInterval timeLength;


///滚动方向，默认横向 UICollectionViewScrollDirectionHorizontal
///只针对内置布局，对自定义 UICollectionViewLayout 无效
@property (nonatomic ,assign) UICollectionViewScrollDirection scrollDirection;


/// 设置自定义cell的名称，会自动注册cell
@property (nonatomic ,copy) NSString *cellName;


/// 轮播图 数组:(所有属性 需在 dataArr 设置前 赋值，之后无效)
/// 数组内数据可为任意类型，BSLooperViewDelegate 会输出目标对象dataArr[indexPath.row]
@property (nonatomic ,strong) NSArray <id>*dataArr;





#pragma mark - method

/// 如果需要不一样的UI，需要自定义轮播图布局
-(void)setCollectionViewLayout:(UICollectionViewLayout *)layout;





@end



#pragma mark - 
@interface TimerTarget : NSObject


@property (nonatomic ,weak) BSLooperView * target;


@end

//
//  BSLooperView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/22.
//

#import <UIKit/UIKit.h>


@class BSLooperView;

@protocol BSLooperViewDelegate <NSObject>

@required

/// BSLooperView cell 赋值
-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@optional

/// cell 点击
-(void)BSLooperView:(BSLooperView *)looperView didSelectIndexPath:(NSIndexPath *)indexPath;


@end




@interface BSLooperView : UIView

@property (nonatomic ,weak) id <BSLooperViewDelegate> delegate;

///是否无限轮播
@property (nonatomic ,assign) BOOL isCircle;


///是否自动轮播(只有无限轮播，才可自动轮播)
@property (nonatomic ,assign) BOOL AUTO;

///滚动方向，默认横向 UICollectionViewScrollDirectionHorizontal
@property (nonatomic ,assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic ,strong) UICollectionViewCell *collectionCell;


@property (nonatomic ,strong) UICollectionView *collectionView;


@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;


@end



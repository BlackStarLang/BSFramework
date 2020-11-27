//
//  UIScrollView+BSRefresh.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/11/11.
//

#import <UIKit/UIKit.h>
#import "BSRefreshHeaderView.h"
#import "BSRefreshFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (BSRefresh)<UIScrollViewDelegate>




// =========================================
// Header 和 Footer
// =========================================
@property (nonatomic ,strong) BSRefreshHeaderView *bsHeader;
@property (nonatomic ,strong) BSRefreshFooterView *bsFooter;






// =========================================
// Block 回调
// =========================================

/// 普通刷新
@property (nonatomic ,copy) void(^headerRefreshBlock)(UIScrollView *refreshView);
@property (nonatomic ,copy) void(^footerRefreshBlock)(UIScrollView *refreshView);

/// 仅动画刷新，无文字
@property (nonatomic ,copy) void(^headerNoTextRefreshBlock)(UIScrollView *refreshView);
@property (nonatomic ,copy) void(^footerNoTextRefreshBlock)(UIScrollView *refreshView);

// =========================================
// 预加载更多功能：
// 条件：当前contentSize.height大于屏幕长度 100 单位 开启
// 激活block回调条件：contentSize.height - SCREEN_HEIGHT <= 80
// =========================================

@property (nonatomic ,copy) void(^footerPreLoadBlock)(UIScrollView *refreshView);


/// 是否是预加载
@property (nonatomic ,assign,readonly) BOOL preLoad;


/// 加载更多是，没有更多数据处理
@property (nonatomic ,assign) BOOL noMoreData;






// =========================================
// 结束刷新动画
// =========================================
#pragma mark - 结束刷新动画

/// 结束header刷新动画
-(void)endHeaderRefresh;

/// 结束footer刷新动画
-(void)endFooterRefresh;

/// 结束header 和 footer 刷新动画
-(void)endAllRefresh;


@end

NS_ASSUME_NONNULL_END

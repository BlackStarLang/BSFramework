//
//  BSHeaderFooterView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/11/24.
//

#import <UIKit/UIKit.h>
#import "BSRefreshConfig.h"


@interface BSHeaderFooterView : UIView

@property (nonatomic ,strong) UILabel *desLabel;

@property (nonatomic ,strong) UIImageView *refreshImageView;

@property (nonatomic ,assign) BSSTATUS BSStatus;

@property (nonatomic ,strong) UIScrollView *scrollView;

///=============================
/// emptyText = YES 时，将不显示描述文字
/// 默认 emptyText = NO
///=============================
@property (nonatomic ,assign) BOOL emptyText;


///=============================
/// 各个状态对应的文字
/// 默认：statusTitleArr = @[@"下拉刷新",@"松手进行刷新",@"正在刷新..."]
/// 无法设置nil ,如果不需要文字 ，通过 属性emptyText
///=============================

@property (nonatomic ,strong) NSArray *statusTitleArr;



///===============================
/// method
///===============================

-(void)updateFrame:(CGRect)frame;


-(void)bsScrollViewDidScrolled:(UIScrollView *)scrollView;


-(void)headerBlockCallBack;
-(void)footerBlockCallBack;



@end



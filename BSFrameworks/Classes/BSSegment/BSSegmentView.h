//
//  BSSegmentView.h
//  BSFrameworks
//
//  Created by zongheng on 2023/3/21.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, barTitleAligmentType) {
    barTitleAligmentType_Bottom = 0,  ///底部对齐 默认
    barTitleAligmentType_CenterY,     ///纵向居中
    barTitleAligmentType_Top,         ///顶部对齐
};

typedef NS_ENUM(NSUInteger, barTitleScrollAligment) {
    barTitleScrollAligment_Normal = 0,  ///不处理
    barTitleScrollAligment_CenterX,     ///默认横向居中
};


@interface BSSegmentView : UIView

///联动的scrollView，通过监听scrollView的contentoffset变化来处理联动效果
@property (nonatomic, weak) UIScrollView *linkScrollView;
///滚动指示器(底部横条)的宽度比 label 长多少：默认 3
@property (nonatomic, assign) CGFloat indicatorGreatLabelWidth;
///每个标题之间的间距
@property (nonatomic, assign) CGFloat lineSpace;
///默认 1.5
@property (nonatomic, assign) CGFloat headIndent;
///默认 15
@property (nonatomic, assign) CGFloat tailIndent;

///设置内容居中展示，适用于个数固定居中展示的样式，如：男生 女生 样式
///此种样式 headIndent/tailIndent 无效，contentView的centerX固定为中间，
///且scrollView不会设置contentSize，即不会滚动
@property (nonatomic, assign) BOOL contentViewLayoutCenter;


///普通字体和选中后的字体
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectFont;

///普通字体颜色和选中后的字体颜色
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

///标题对齐类型
@property (nonatomic, assign) barTitleAligmentType aligmentType;
//纵向偏移，负数为上偏倚，正数下偏移
@property (nonatomic, assign) CGFloat verticalOffsetY;

///选中标题后，标题是否自动滚动到中间
@property (nonatomic, assign) barTitleScrollAligment autoScrollType;
///被选中的item自动滚动后，需要的横向偏移量，负数为向左，正数为向右
///只有在 barTitleScrollAligment_CenterX 状态下有用
@property (nonatomic, assign) CGFloat horizontalAutoOffsetX;

///默认选中index
@property (nonatomic, assign) NSUInteger defaultSelectIndex;

///设置标题数据
- (void)setDataArr:(NSArray<NSString *> *)dataArr;

///设置选中的标签,只能在 setDataArr 方法之后
- (void)setSelectIndex:(NSInteger)selectIndex animate:(BOOL)animate;

///设置底部横线的颜色或图片，如果都设置，以图片优先
- (void)setIndicatorLineColor:(UIColor *)lineColor orImage:(UIImage *)image;

@end



//
//  BSSegmentView.m
//  BSFrameworks
//
//  Created by zongheng on 2023/3/21.
//

#import "BSSegmentView.h"
#import <UIView+BSView.h>

@interface BSSegmentView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *lineIndicator;

@property (nonatomic, strong) NSArray *mutLabels;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger willSelectIndex;

///是点击
@property (nonatomic, assign) BOOL isTaped;

@end


@implementation BSSegmentView

#pragma mark - lifyCycle

- (void)dealloc {

    @try {
        [self.linkScrollView removeObserver:self forKeyPath:@"contentOffset"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefaultData];
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setupLayouts];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.contentViewLayoutCenter){
        self.contentView.centerX = self.scrollView.width/2;
    }
}

#pragma mark - config default data

- (void)configDefaultData {
    self.autoScrollType = barTitleScrollAligment_CenterX;
    self.horizontalAutoOffsetX = 0;
    self.isTaped = NO;
    self.aligmentType = barTitleAligmentType_Bottom;
    self.headIndent = 1.5;
    self.tailIndent = 15;
    self.indicatorGreatLabelWidth = 3;
}

#pragma mark - setupViews && setupLayouts

- (void)setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
}

- (void)setupLayouts {
    self.scrollView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.contentView.left = self.headIndent;
}

- (void)refreshAllTabFrame {
    
     UILabel *lastLabel = nil;
    
    for (int i = 0; i<self.mutLabels.count; i++) {
        
        UILabel *label = self.mutLabels[i];
        label.left = lastLabel.right + (i==0?0:self.lineSpace);
       
        ///根据title布局类型，设置不同的对齐方式
        if (self.aligmentType == barTitleAligmentType_Top) {
            label.top = self.verticalOffsetY;
        }else if(self.aligmentType == barTitleAligmentType_CenterY) {
            label.centerY = self.contentView.height/2 + self.verticalOffsetY;
        }else{
            label.bottom = self.contentView.height + self.verticalOffsetY;
        }
        
        lastLabel = label;
    }
    
    ///由于字数不统一，会导致 titleLabel 放大后控件的总长度发生改变，
    ///所以每次都需要计算内容宽度和滚动的ContentSize
    self.contentView.width = lastLabel.right;
    
    ///居中样式认为不可滚动，所以不需要计算contentSize
    if (!self.contentViewLayoutCenter) {
        CGFloat scrollContentWidth = self.headIndent + self.contentView.width + self.tailIndent;
        [self.scrollView setContentSize:CGSizeMake(scrollContentWidth, self.scrollView.height)];
    }
}


#pragma mark - action

- (void)titleLabelTaped:(UIGestureRecognizer *)gesture {
    self.isTaped = YES;
    self.userInteractionEnabled = NO;
    
    if (self.didClickTabBlock){
        self.didClickTabBlock(gesture.view.tag);
    }
    [self setSelectIndex:gesture.view.tag animate:YES];
    
    // 这里认为点击标签后，动画0.35s内一定会结束
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        self.isTaped = NO;
    });
}


#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.linkScrollView && [keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat contentOffsetX = self.linkScrollView.contentOffset.x;
        if (contentOffsetX <0) return;
        
        if (self.isTaped){
            
            UILabel *currentLabel = self.mutLabels[self.currentIndex];
            UILabel *willSelectLabel = self.mutLabels[self.willSelectIndex];
            
            CGFloat targetDistance = (labs((self.willSelectIndex - self.currentIndex)) * SCREEN_WIDTH);
            CGFloat currentOffset = fabs((contentOffsetX - self.currentIndex * SCREEN_WIDTH));
            
            CGFloat progress = currentOffset/targetDistance;
            
            CGFloat scale = self.normalFont.lineHeight/self.selectFont.lineHeight;
            CGFloat secondScale = 1 + (scale - 1) * progress;
            CGFloat firstScale = scale - (scale - 1) * progress;
            
            currentLabel.transform = CGAffineTransformMakeScale(secondScale, secondScale);
            willSelectLabel.transform = CGAffineTransformMakeScale(firstScale, firstScale);
            
            [self refreshAllTabFrame];
            
            willSelectLabel.textColor = [self colorTransformFrom:self.normalColor to:self.selectColor progress:progress];
            currentLabel.textColor = [self colorTransformFrom:self.selectColor to:self.normalColor progress:(progress)];
            
            CGFloat totalWidth = currentLabel.left - willSelectLabel.left;
            ///调整布局任务放在队列最后
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.lineIndicator.left = currentLabel.left - totalWidth * progress;
                self.lineIndicator.width = currentLabel.width + (willSelectLabel.width - currentLabel.width) * progress;
            });
            
            [self autoSetContentOffset:contentOffsetX isTaped:YES];

        }else{
            
            NSInteger pageIndex = contentOffsetX/SCREEN_WIDTH;
            if (pageIndex + 1 >= self.mutLabels.count) return;
            
            UILabel *firstLabel = self.mutLabels[pageIndex];
            UILabel *secondLabel = self.mutLabels[pageIndex + 1];
            
            CGFloat progress = (contentOffsetX - pageIndex * SCREEN_WIDTH)/SCREEN_WIDTH;
            
            CGFloat scale = self.normalFont.lineHeight/self.selectFont.lineHeight;
            
            CGFloat secondScale = 1 + (scale - 1) * progress;
            CGFloat firstScale = scale - (scale - 1) * progress;
            
            firstLabel.transform = CGAffineTransformMakeScale(secondScale, secondScale);
            secondLabel.transform = CGAffineTransformMakeScale(firstScale, firstScale);
            
            [self refreshAllTabFrame];
            
            secondLabel.textColor = [self colorTransformFrom:self.normalColor to:self.selectColor progress:progress];
            firstLabel.textColor = [self colorTransformFrom:self.selectColor to:self.normalColor progress:(progress)];
            
            if (progress < 0.5) {
                self.lineIndicator.left = firstLabel.left - self.indicatorGreatLabelWidth/2;
                self.lineIndicator.width = firstLabel.width + progress * (secondLabel.width + self.lineSpace) * 2 + self.indicatorGreatLabelWidth;
            }else{
                self.lineIndicator.width = secondLabel.width + (1-progress) * (firstLabel.width + self.lineSpace) * 2 + self.indicatorGreatLabelWidth;
                self.lineIndicator.centerX = secondLabel.centerX - (1-progress) * (firstLabel.width + self.lineSpace);
            }
            
            [self autoSetContentOffset:contentOffsetX isTaped:NO];
        }
    }
}


#pragma mark - public

- (void)setDataArr:(NSArray *)dataArr {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (dataArr.count <= 0) return;
    [self.contentView addSubview: self.lineIndicator];
    
    NSMutableArray *mutLabel = [NSMutableArray array];

    UILabel *lastLabel = nil;
    NSInteger selectIndex = MIN(dataArr.count - 1, self.defaultSelectIndex);

    for (int i = 0; i<dataArr.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:titleLabel];
        [mutLabel addObject:titleLabel];
        
        NSString *title = dataArr[i];
        
        CGFloat width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.selectFont.pointSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.selectFont} context:nil].size.width;
        
        ///这里Y不赋值，后边 refreshAllTabFrame 会重新赋值
        titleLabel.frame = CGRectMake(lastLabel.right + self.lineSpace , 0, width, self.selectFont.pointSize);
        titleLabel.font = self.selectFont;
        titleLabel.tag = i;
        titleLabel.textColor = (i == selectIndex)?self.selectColor:self.normalColor;
        titleLabel.text = dataArr[i];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (i != selectIndex) {
            CGFloat scale = self.normalFont.lineHeight/self.selectFont.lineHeight;
            titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelTaped:)];
        [titleLabel addGestureRecognizer:tap];
        
        lastLabel = titleLabel;
    }
    
    self.mutLabels = [mutLabel copy];
    
    ///因为有一个被缩放了，需要重新排版button的left、bottom
    [self refreshAllTabFrame];
    
    UILabel *selectLabel = mutLabel[selectIndex];
    ///重置label.frame 后，通过 selectLabel 找到横线初始位置
    self.lineIndicator.frame = CGRectMake(selectLabel.left - self.indicatorGreatLabelWidth/2, selectLabel.bottom - SCALE_W(3), selectLabel.width + self.indicatorGreatLabelWidth, SCALE_W(6));
    
    ///自动滚动
    [self autoSetContentOffset:selectIndex * SCREEN_WIDTH isTaped:NO];
    [self.linkScrollView setContentOffset:CGPointMake(selectIndex * SCREEN_WIDTH, 0) animated:NO];
}

- (void)setLinkScrollView:(UIScrollView *)linkScrollView {
    _linkScrollView = linkScrollView;
    [linkScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setHeadIndent:(CGFloat)headIndent {
    _headIndent = headIndent;
    self.contentView.left = headIndent;
}

- (void)setSelectIndex:(NSInteger)selectIndex animate:(BOOL)animate {
    
    self.currentIndex = round(self.linkScrollView.contentOffset.x/SCREEN_WIDTH);
    self.willSelectIndex = selectIndex;
    [self.linkScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * self.willSelectIndex, 0) animated:animate];
}

- (void)setIndicatorLineColor:(UIColor *)lineColor orImage:(UIImage *)image{
    if (image){
        self.lineIndicator.image = image;
    }else{
        self.lineIndicator.backgroundColor = lineColor;
    }
}

#pragma mark - prive

- (UIColor *)colorTransformFrom:(UIColor*)fromColor to:(UIColor *)toColor progress:(CGFloat)progress {
    if (!fromColor || !toColor) {
        return [UIColor blackColor];
    }

    progress = progress >= 1 ? 1 : progress;

    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
    
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
    
    CGFloat red = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat green = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat blue = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    CGFloat alpha = 1;
    if (fromColorNumber>3 && toColorNumber>3) {
        alpha = fromeComponents[3]*(1 - progress) + toComponents[3]*progress;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


- (void)autoSetContentOffset:(CGFloat)contentOffsetX isTaped:(BOOL)isTaped {
    
    if (self.autoScrollType == barTitleScrollAligment_CenterX){
        CGFloat minOffsetX = MAX(self.lineIndicator.centerX - self.scrollView.width/2 + self.horizontalAutoOffsetX, 0);
        CGFloat minOffsetX1 = MAX(self.scrollView.contentSize.width - self.scrollView.width, 0);
        CGFloat newOffsetX = MIN(minOffsetX, minOffsetX1);
        
        ///点击的时候需要考虑跨度问题，所以需要判断是向左还是向右，这样可以优化滚动效果
        if(isTaped){
            if (self.currentIndex <= self.willSelectIndex ){
                if(newOffsetX >= self.scrollView.contentOffset.x){
                    [self.scrollView setContentOffset:CGPointMake(newOffsetX , 0)];
                }
            }else{
                if(newOffsetX < self.scrollView.contentOffset.x){
                    [self.scrollView setContentOffset:CGPointMake(newOffsetX , 0)];
                }
            }
        }else{
            ///滚动的时候不需要考虑跨度问题，两个标签一定是挨着的，所以直接滚动就行
            [self.scrollView setContentOffset:CGPointMake(newOffsetX , 0)];
        }
    }
}


#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}


- (UIImageView *)lineIndicator {
    if (!_lineIndicator) {
        _lineIndicator = [[UIImageView alloc]init];
        _lineIndicator.layer.cornerRadius = 3.5;
        _lineIndicator.layer.masksToBounds = YES;
//        _lineIndicator.image = [UIImage imageNamed:@"segment_indicator"];
    }
    return _lineIndicator;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

@end

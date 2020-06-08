//
//  BSPhotoNaviView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/6/8.
//

#import "BSPhotoNaviView.h"
#import "Masonry.h"

@interface BSPhotoNaviView ()

@property (nonatomic ,strong) UIVisualEffectView *visualView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;

@property (nonatomic ,strong) UIImageView *backImageView;

@end

@implementation BSPhotoNaviView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

-(void)initSubViews{
    
    //设置UIVisualEffectView 毛玻璃
    [self addSubview:self.visualView];
    
    [self.leftBtn addSubview:self.backImageView];
    [self addSubview:self.leftBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
    
}


-(void)masonryLayout{
    
    [self.visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.leftBtn.mas_right).offset(5);
        make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.leftBtn);
        make.centerX.offset(0);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_greaterThanOrEqualTo(40);
        make.right.offset(-15);
    }];
    
    [self.leftBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Set Method

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor = titleColor;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    
    if ([self isLighterColor:backgroundColor]) {
        self.backImageView.tintColor = [UIColor blueColor];
    }else{
        self.backImageView.tintColor = [UIColor whiteColor];
    }
    self.visualView.backgroundColor = backgroundColor;
}


- (BOOL)isLighterColor:(UIColor *)color {
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}


-(void)setIsPure:(BOOL)isPure{
    if (isPure) {
        self.visualView.hidden = YES;
    }else{
        self.visualView.hidden = YES;
    }
}

-(void)setLeftBtnTitle:(NSString *)leftTitle titleColor:(UIColor *)titleColor{
    
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:titleColor forState:UIControlStateNormal];
}


-(void)setRightBtnTitle:(NSString *)rightTitle titleColor:(UIColor *)titleColor{
    
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
}



#pragma mark - action 交互事件

-(void)leftBtnClick{
    
    if (self.naviAction) {
        self.naviAction(YES);
    }
    
}

-(void)rightBtnClick{
    
    if (self.naviAction) {
        self.naviAction(NO);
    }
}


#pragma mark - init 属性初始化

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]init];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(UIVisualEffectView *)visualView{
    if (!_visualView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _visualView.alpha = 0.9;
    }
    return _visualView;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [[UIImage imageNamed:@"navi_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _backImageView.tintColor = [UIColor blueColor];
    }
    return _backImageView;
}

@end

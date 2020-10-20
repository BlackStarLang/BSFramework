//
//  BSVideoBottomView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/20.
//

#import "BSVideoBottomView.h"
#import "UIView+BSView.h"
#import "Masonry.h"

@interface BSVideoBottomView ()<BSPhotoTypeSelectViewDelegate>


@end


@implementation BSVideoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}


-(void)initSubViews{
    
    self.selectType = SELECTTYPE_PIC;

    [self addSubview:self.alphaView];
    [self addSubview:self.takeBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.nextBtn];
    [self addSubview:self.typeSelView];
    
}


-(void)masonryLayout{
    
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.height.mas_equalTo(80);
        make.bottom.offset(-25);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takeBtn.mas_left).offset(-(SCREEN_WIDTH/2 - 40)/2);
        make.centerY.equalTo(self.takeBtn);
        make.height.mas_equalTo(30);
    }];

    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takeBtn.mas_right).offset((SCREEN_WIDTH/2 - 40)/2);
        make.centerY.equalTo(self.takeBtn);
        make.height.mas_equalTo(30);
    }];
}


#pragma mark - action 交互事件

-(void)cancelBtnClick{
    
    if ([self.cancelBtn.titleLabel.text isEqualToString:@"重拍"] && self.selectType == SELECTTYPE_PIC) {
        
        if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didClickFuncBtnWithType:)]) {
            [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_RETRY];
        }
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didClickFuncBtnWithType:)]) {
            [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_BACK];
        }
    }
}

-(void)nextBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didClickFuncBtnWithType:)]) {
        [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_NEXT];
    }
}


-(void)takeBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didClickFuncBtnWithType:)]) {
        
        if (self.selectType == SELECTTYPE_PIC) {
            
            [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_PIC_RECORDED];
        }else{
            
            if (self.takeBtn.selected == YES) {
                [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_VIDEO_RECORDING];
            }else{
                [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_PIC_RECORDED];
            }
        }
    }
}



#pragma mark - priveDelegate 私有代理
-(void)BSPhotoTypeSelectViewSelectedType:(SELECTTYPE)selectType{
    
    self.selectType = selectType;
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.alpha = (selectType==SELECTTYPE_PIC)?1:0.2;
    }];
    
    if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didSelectType:)]) {
        [self.delegate BSVideoBottomView:self didSelectType:selectType];
    }
}



#pragma mark - init 属性初始化

-(UIView *)alphaView{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = [UIColor blackColor];
    }
    return _alphaView;
}

-(BSVideoTakeBtn *)takeBtn{
    if (!_takeBtn) {
        _takeBtn = [[BSVideoTakeBtn alloc]init];
        [_takeBtn addMyTarget:self action:@selector(takeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takeBtn;
}


-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        _nextBtn.hidden = YES;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;;
}


-(BSPhotoTypeSelectView *)typeSelView{
    if (!_typeSelView) {
        _typeSelView = [[BSPhotoTypeSelectView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 40)];
        _typeSelView.delegate = self;
    }
    return _typeSelView;
}


@end










#pragma mark - 拍照按钮封装
@implementation BSVideoTakeBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

-(void)initSubViews{
    [self addSubview:self.takeBtn];
    
//    self.circleLayer = [[CALayer alloc]init];
//    self.circleLayer.borderWidth = 3;
//    self.circleLayer.borderColor = [UIColor redColor].CGColor;
//
//    [self.layer addSublayer:self.circleLayer];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(3, 3, self.width - 6, self.height - 6) cornerRadius:self.width/2];
    
}

-(void)masonryLayout{
    
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(3);
        make.right.bottom.offset(-3);
    }];
    
}

#pragma mark - action 交互事件

-(void)addMyTarget:(NSObject *)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    [self.takeBtn addTarget:target action:action forControlEvents:controlEvents];
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *curView = [super hitTest:point withEvent:event];

    if (curView == self.takeBtn) {

        CGPoint center = self.takeBtn.center;

        CGFloat distance = sqrt(pow((point.x - center.x),2) + pow((point.y - center.y),2));

        if (distance<=self.width) {
            return self.takeBtn;
        }

    }
    return curView;
}


#pragma mark - init 属性初始化

- (UIButton *)takeBtn{
    if (!_takeBtn) {
        _takeBtn = [[UIButton alloc]init];
        [_takeBtn setImage:[UIImage imageNamed:@"photo_camera_take"] forState:UIControlStateNormal];
    }
    return _takeBtn;
}


@end

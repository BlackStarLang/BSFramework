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

@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) int timeCount;

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
    self.recordStatus = RECORD_STATUS_UNRECORD;

    [self addSubview:self.alphaView];
    [self addSubview:self.videoTimeLabel];
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
        make.width.height.mas_equalTo(70);
        make.bottom.offset(-30);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takeBtn.mas_left).offset(-(SCREEN_WIDTH/2 - 30)/2);
        make.centerY.equalTo(self.takeBtn);
        make.width.height.mas_equalTo(44);
    }];

    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takeBtn.mas_right).offset((SCREEN_WIDTH/2 - 30)/2);
        make.centerY.equalTo(self.takeBtn);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(5);
        make.right.offset(-5);
        make.height.mas_equalTo(30);
    }];
}


#pragma mark - action 交互事件

-(void)cancelBtnClick{
    self.videoTimeLabel.hidden = YES;
    if (self.recordStatus != RECORD_STATUS_UNRECORD) {
        
        if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didClickFuncBtnWithType:)]) {
            [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_RETRY];
            self.recordStatus = RECORD_STATUS_UNRECORD;
            [self refreshUIHiddenStatusIsHidden:NO];
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
    
    self.takeBtn.selected = !self.takeBtn.selected;
    
    if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didClickFuncBtnWithType:)]) {
        
        if (self.selectType == SELECTTYPE_PIC) {
            
            self.recordStatus = RECORD_STATUS_RECORDING;
            [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_PIC];
                        
        }else{
            
            if (self.takeBtn.selected == YES) {
                self.recordStatus = RECORD_STATUS_RECORDING;
                [self.takeBtn actionToAnimateTranslationForRecording:YES fillCorlor:[UIColor redColor]];
                [self startTime];
            }else{
                self.recordStatus = RECORD_STATUS_RECORDED;
                [self.takeBtn actionToAnimateTranslationForRecording:NO fillCorlor:[UIColor redColor]];
                [self stopTime];
            }

            [self.delegate BSVideoBottomView:self didClickFuncBtnWithType:FUNC_TYPE_VIDEO];
            [self takeBtnLayerAnimate];
        }
        
        [self refreshUIHiddenStatusIsHidden:YES];
    }
}


// 点击录制按钮后，开始按钮动画
-(void)takeBtnLayerAnimate{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.takeBtn.takeBtn.frame = CGRectMake(0, 0, 20, 30);
    }];
}


-(void)startTime{
    
    self.videoTimeLabel.hidden = (self.selectType==1);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAddCount) userInfo:nil repeats:YES];
}


-(void)timeAddCount{
    
    self.timeCount ++ ;
    self.videoTimeLabel.text = [self getTimeStr];
}


-(NSString *)getTimeStr{
    
    NSString *timeStr = @"00:00:00";
    if (self.timeCount<60) {
        
        timeStr = [NSString stringWithFormat:@"00:00:%02d",self.timeCount];

    }else if (self.timeCount>=60 && self.timeCount<=3600){
        
        timeStr = [NSString stringWithFormat:@"00:%02d:%02d",self.timeCount/60,self.timeCount%60];

    }else{
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",self.timeCount/3600,self.timeCount/60,self.timeCount%60];

    }
    
    return timeStr;
}


-(void)stopTime{
 
    [self.timer invalidate];
    self.timer = nil;
    self.timeCount = 0;
}


#pragma mark - Public Method

-(void)refreshUIHiddenStatusIsHidden:(BOOL)hidden{
    
    self.nextBtn.hidden = !hidden;
    self.takeBtn.hidden = hidden;
    if (self.mediaType == 2) {
        self.typeSelView.hidden = hidden;
    }
    self.cancelBtn.hidden = NO;
    
    if (self.selectType == SELECTTYPE_VIDEO) {
        
        if (self.recordStatus == RECORD_STATUS_RECORDED) {
            self.takeBtn.hidden = YES;
            self.nextBtn.hidden = NO;
        }else{
            self.takeBtn.hidden = NO;
            self.nextBtn.hidden = YES;
        }

        if (self.recordStatus == RECORD_STATUS_RECORDING) {
            self.cancelBtn.hidden = YES;
        }
    }
}


-(void)setSelectType:(SELECTTYPE)selectType{
    [self BSPhotoTypeSelectViewSelectedType:selectType];
}


#pragma mark - priveDelegate 私有代理
-(void)BSPhotoTypeSelectViewSelectedType:(SELECTTYPE)selectType{
    
    _selectType = selectType;

    self.takeBtn.selected = NO;
    self.recordStatus = RECORD_STATUS_UNRECORD;
    
    [self refreshUIHiddenStatusIsHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.alpha = (selectType==SELECTTYPE_PIC)?1:0.2;
    }];
    
    if ([self.delegate respondsToSelector:@selector(BSVideoBottomView:didSelectType:)]) {
        [self.delegate BSVideoBottomView:self didSelectType:selectType];
    }
    
    UIColor *fillColor = (selectType==SELECTTYPE_PIC?[UIColor whiteColor]:[UIColor redColor]);
    [self.takeBtn actionToAnimateTranslationForRecording:NO fillCorlor:fillColor];
}



#pragma mark - init 属性初始化

-(UIView *)alphaView{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = [UIColor blackColor];
    }
    return _alphaView;
}


-(UILabel *)videoTimeLabel{
    if (!_videoTimeLabel) {
        _videoTimeLabel = [[UILabel alloc]init];
        _videoTimeLabel.textAlignment = 1;
        _videoTimeLabel.textColor = [UIColor whiteColor];
        _videoTimeLabel.font = [UIFont systemFontOfSize:16];
        _videoTimeLabel.hidden = YES;
        _videoTimeLabel.text = @"00:00:00";
    }
    return _videoTimeLabel;
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
        [_cancelBtn setImage:[UIImage imageNamed:@"photo_camera_back"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        _nextBtn.hidden = YES;
        [_nextBtn setImage:[UIImage imageNamed:@"photo_camera_next"] forState:UIControlStateNormal];
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

@interface BSVideoTakeBtn ()<CAAnimationDelegate>



@end


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
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 35;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 5;
    self.layer.masksToBounds = YES;

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(7, 7, 28*2, 28*2) cornerRadius:28];
    
    self.shapLayer = [CAShapeLayer layer];
    self.shapLayer.path = bezierPath.CGPath;
    self.shapLayer.fillColor = [UIColor whiteColor].CGColor;
    
    [self.layer addSublayer:self.shapLayer];
    
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



-(void)actionToAnimateTranslationForRecording:(BOOL)recording fillCorlor:(UIColor *)fillCorlor{
    
    self.shapLayer.fillColor = fillCorlor.CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(7, 7, 28*2, 28*2) cornerRadius:28];
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(17, 17, 18*2, 18*2) cornerRadius:8];

    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.duration = 0.2;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    if (recording) {
        basicAnimation.fromValue = (__bridge id _Nullable)(self.shapLayer.path);
        basicAnimation.toValue = (__bridge id _Nullable)(bezierPath1.CGPath);
    }else{
        basicAnimation.fromValue = (__bridge id _Nullable)(self.shapLayer.path);
        basicAnimation.toValue = (__bridge id _Nullable)(bezierPath.CGPath);
    }
    
    [self.shapLayer addAnimation:basicAnimation forKey:@"path"];
}

#pragma mark - init 属性初始化

- (UIButton *)takeBtn{
    if (!_takeBtn) {
        _takeBtn = [[UIButton alloc]init];
    }
    return _takeBtn;
}


@end

//
//  BSHeaderFooterView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/11/24.
//

#import "BSHeaderFooterView.h"
#import "UIView+BSView.h"


@implementation BSHeaderFooterView


#pragma mark - 生命周期

-(void)willMoveToSuperview:(UIView *)newSuperview{
        
    if (!newSuperview) {
        [self removeObserver];
    }else{
        [self addObserver];
    }
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    self.backgroundColor = [UIColor whiteColor];
    self.BSStatus = BS_STATUS_NORMAL;

    [self addSubview:self.desLabel];
    [self addSubview:self.refreshImageView];

}

-(void)setBSStatus:(BSSTATUS)BSStatus{
    
    _BSStatus = BSStatus;

    
    if (BSStatus == BS_STATUS_NORMAL) {
        
        [self.refreshImageView.layer removeAllAnimations];
        
    }else if (BSStatus == BS_STATUS_REFRESHING){
        
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnimation.duration = 1;
        basicAnimation.repeatCount = MAXFLOAT;
        basicAnimation.removedOnCompletion = NO;
        [basicAnimation setToValue:@(M_PI * 2)];

        [self.refreshImageView.layer addAnimation:basicAnimation forKey:@"refresh_rotation"];
        
    }else if (BSStatus == BS_STATUS_WILL_REFRESHING){
        
        
    }
    
    if (!self.emptyText) {
        self.desLabel.text = self.statusTitleArr[BSStatus];
    }
}



-(void)updateFrame:(CGRect)frame{
    
    if (frame.size.width>0) {
        
        self.frame = frame;
        self.desLabel.hidden = self.emptyText;
        
        if (self.emptyText) {
            self.refreshImageView.frame = CGRectMake(self.centerX - 10, 10, 20, 20);
        }else{
            self.refreshImageView.frame = CGRectMake(self.centerX - 60, 10, 20, 20);
            CGFloat desWidth = SCREEN_WIDTH -(self.centerX - 30);
            self.desLabel.frame = CGRectMake(self.centerX - 30, 10, desWidth , 20);
        }
    }
}


#pragma mark - observer
-(void)addObserver{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserver{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}



#pragma mark - 监听 ScrollView contentOffset
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    [self bsScrollViewDidScrolled: (UIScrollView *)object];
    [self updateHeaderFooterFrame];
    
    [self leaveDraggingEventWithScrollView:(UIScrollView *)object];
}


-(void)bsScrollViewDidScrolled:(UIScrollView *)scrollView{
    
}


-(void)updateHeaderFooterFrame{

    if (self.width <=0) {
        if ([self respondsToSelector:@selector(updateFrame:)]) {
            [self updateFrame:CGRectMake(0, -60, self.width, 60)];
        }
    }
    
    CGFloat footerY = MAX(self.scrollView.height - STATUSNAVIBAR_HEIGHT , self.scrollView.contentSize.height + 12);
    
    if (self.top != footerY) {

        if ([self respondsToSelector:@selector(updateFrame:)]) {
            [self updateFrame:CGRectMake(0, footerY, self.width, 60)];
        }
    }
}



#pragma mark 处理手势拖拽的事件
-(void)leaveDraggingEventWithScrollView:(UIScrollView *)scrollView{
    
    
}



#pragma mark 执行 block 回调

-(void)headerBlockCallBack{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"bsHeaderBlockCallBack" object:@""];
}


-(void)footerBlockCallBack{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"bsFooterBlockCallBack" object:@""];
}




#pragma mark - init 属性初始化

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.font = [UIFont systemFontOfSize:15];
    }
    return _desLabel;
}


-(UIImageView *)refreshImageView{
    if (!_refreshImageView) {
        _refreshImageView = [[UIImageView alloc]init];
        _refreshImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage *refreshImg = [[UIImage imageNamed:@"bs_refresh3"]imageWithRenderingMode:UIImageRenderingModeAutomatic];
        
        _refreshImageView.image = refreshImg;
        _refreshImageView.tintColor = [UIColor grayColor];
    }
    return _refreshImageView;
}


-(NSArray *)statusTitleArr{
    if (!_statusTitleArr) {
        _statusTitleArr = @[@"   下拉刷新",@"松手进行刷新",@"  正在刷新..."];
    }
    return _statusTitleArr;
}



@end

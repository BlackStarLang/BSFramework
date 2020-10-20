//
//  BSPhotoTypeSelectView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/15.
//

#import "BSPhotoTypeSelectView.h"
#import "Masonry.h"
#import "UIView+BSView.h"

@implementation BSPhotoTypeSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (CGRectEqualToRect(frame, CGRectZero)) {
            assert("初始化需要给出frame");
        }
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}


-(void)initSubViews{
    
    [self addSubview:self.scrollView];
    
    NSArray * btnTitles = @[@"拍照",@"视频"];
    for (int i = 0 ; i<btnTitles.count ; i++) {
        NSString *title = btnTitles[i];
        UIButton *btn = [[UIButton alloc]init];
        if (i == 0) {
            btn.frame = CGRectMake(self.width/2 - 25, 0, 50, self.height);
            btn.selected = YES;
            self.selectType = SELECTTYPE_PIC;
        }else{
            btn.frame = CGRectMake(self.width/2 + 25 , 0, 50, self.height);
        }
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.scrollView addSubview:btn];
        [self.btns addObject:btn];
    }
}


-(void)masonryLayout{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.height.width.mas_equalTo(self);
    }];
    
}

#pragma mark - action 交互事件

-(void)btnClick:(UIButton *)sender{
    
    UIButton *btn1 = self.btns[0];
    UIButton *btn2 = self.btns[1];
    sender.selected = YES;

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        if (sender.tag == 0) {
            self.selectType = SELECTTYPE_PIC;
            btn2.selected = NO;
            btn1.frame = CGRectMake(self.width/2 - 25, 0, 50, self.height);
            btn2.frame = CGRectMake(self.width/2 + 25 , 0, 50, self.height);
        }else{
            self.selectType = SELECTTYPE_VIDEO;
            btn1.selected = NO;
            btn1.frame = CGRectMake(self.width/2 - 75, 0, 50, self.height);
            btn2.frame = CGRectMake(self.width/2 - 25 , 0, 50, self.height);
        }
        
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(BSPhotoTypeSelectViewSelectedType:)]) {
        [self.delegate BSPhotoTypeSelectViewSelectedType:(sender.tag==0?SELECTTYPE_PIC:SELECTTYPE_VIDEO)];
    }
}


#pragma mark - init 属性初始化

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}


-(NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}


@end

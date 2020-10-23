//
//  PhotoListCollectionCell.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/29.
//

#import "PhotoListCollectionCell.h"
#import <Masonry/Masonry.h>
#import "UIView+BSView.h"

@implementation PhotoListCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
   
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}


-(void)initSubViews{
    
    [self addSubview:self.imageView];
    [self addSubview:self.selectBtn];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomAlphaView];
    [self.bottomView addSubview:self.durationLabel];
}


-(void)masonryLayout{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.mas_equalTo(16);
    }];
    
    [self.bottomAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.right.offset(-5);
    }];
}

#pragma mark - action 交互事件

-(void)selectBtnClick:(UIButton *)sender{
    
    if (self.selectAction) {
        self.selectAction(sender);
    }
}


/// 扩大 选择按钮点击范围
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *view = [super hitTest:point withEvent:event];
    
    if ([view isKindOfClass:[UIImageView class]]) {
        if (self.width - 35 <= point.x && point.y <= 35 && self.selectBtn.hidden == NO) {
            return self.selectBtn;
        }
    }

    return [super hitTest:point withEvent:event];
}


#pragma mark - init 属性初始化

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.masksToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;;
}

-(UIButton *)selectBtn{
    
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setAdjustsImageWhenHighlighted:NO];
        [_selectBtn setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;;
}


-(UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}


-(UIView *)bottomAlphaView{
    
    if (!_bottomAlphaView) {
        _bottomAlphaView = [[UIView alloc]init];
        _bottomAlphaView.alpha = 0.1;
        _bottomAlphaView.backgroundColor = [UIColor blackColor];
    }
    return _bottomAlphaView;
}


-(UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc]init];
        _durationLabel.textAlignment = 2;
        _durationLabel.font = [UIFont systemFontOfSize:12];
        _durationLabel.textColor = [UIColor whiteColor];
    }
    return _durationLabel;
}

@end

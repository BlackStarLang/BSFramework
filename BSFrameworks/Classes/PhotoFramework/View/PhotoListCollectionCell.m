//
//  PhotoListCollectionCell.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/29.
//

#import "PhotoListCollectionCell.h"
#import <Masonry/Masonry.h>

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
}

#pragma mark - action 交互事件

-(void)selectBtnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
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
        [_selectBtn setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;;
}


@end

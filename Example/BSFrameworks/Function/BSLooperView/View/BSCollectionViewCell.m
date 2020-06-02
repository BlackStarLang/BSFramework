//
//  BSCollectionViewCell.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/5/22.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSCollectionViewCell.h"
#import <Masonry.h>

@implementation BSCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}


-(void)initSubViews{
    
    [self.contentView addSubview:self.cellImageView];
    self.contentView.layer.masksToBounds = YES;
}

-(void)masonryLayout{
    
    [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    
}


-(UIImageView *)cellImageView{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc]init];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        _cellImageView.backgroundColor = [UIColor redColor];
    }
    return _cellImageView;
}


@end

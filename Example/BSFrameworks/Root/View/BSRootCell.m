//
//  BSRootCell.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/4.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSRootCell.h"
#import <Masonry.h>

@implementation BSRootCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

-(void)initSubViews{
    
    self.titleLabel.layer.masksToBounds = YES;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.indexLabel];
}

-(void)masonryLayout{
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.bottom.offset(-15);
        make.width.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.bottom.offset(-15);
        make.left.equalTo(self.indexLabel.mas_right).offset(0);
        make.right.offset(-20);
    }];
}


#pragma mark - init 属性初始化

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = 0;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}


-(UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc]init];
        _indexLabel.textAlignment = 0;
        _indexLabel.font = [UIFont systemFontOfSize:15];
        _indexLabel.backgroundColor = [UIColor whiteColor];
    }
    return _indexLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

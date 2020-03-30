//
//  PhotoGroupListCell.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import "PhotoGroupListCell.h"
#import <Masonry/Masonry.h>

@implementation PhotoGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self initSubViews];
        [self masonryLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


-(void)initSubViews{
    self.separatorInset = UIEdgeInsetsZero;//UIEdgeInsetsMake(0, 15, 0, 15);
    [self.contentView addSubview:self.thumbImgView];
    [self.contentView addSubview:self.groupNameLabel];
    [self.contentView addSubview:self.countLabel];
}


-(void)masonryLayout{
    
    [self.thumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.bottom.offset(-15);
        make.height.priorityHigh().mas_equalTo(60);
        make.width.mas_offset(60);
    }];
    
    [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbImgView.mas_right).offset(15);
        make.centerY.equalTo(self.thumbImgView);
        make.right.offset(-15);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.thumbImgView);
    }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - init 属性初始化

-(UIImageView *)thumbImgView{
    if (!_thumbImgView) {
        _thumbImgView = [[UIImageView alloc]init];
        _thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImgView.layer.masksToBounds = YES;
    }
    return _thumbImgView;;
}

-(UILabel *)groupNameLabel{
    
    if (!_groupNameLabel) {
        _groupNameLabel = [[UILabel alloc]init];
        _groupNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _groupNameLabel;
}

-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:100/255.0];
        _countLabel.textAlignment = 2;
    }
    return _countLabel;;
}

@end

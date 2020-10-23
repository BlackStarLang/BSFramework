//
//  PhotoPreviewVideoCell.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/23.
//

#import "PhotoPreviewVideoCell.h"
#import "UIView+BSView.h"
#import "Masonry.h"

@implementation PhotoPreviewVideoCell


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
    [self.contentView.layer addSublayer:self.playerLayer];

}


-(void)masonryLayout{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
    }];
}

#pragma mark - init 属性初始化

-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer layer];
        _playerLayer.frame = CGRectMake(10, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _playerLayer;
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.masksToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;;
}


@end

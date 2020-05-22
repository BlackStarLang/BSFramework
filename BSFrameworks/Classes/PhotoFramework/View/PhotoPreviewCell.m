//
//  PhotoPreviewCell.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/30.
//

#import "PhotoPreviewCell.h"
#import "Masonry.h"

@implementation PhotoPreviewCell

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
}


-(void)masonryLayout{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
    }];
}



#pragma mark - init 属性初始化

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

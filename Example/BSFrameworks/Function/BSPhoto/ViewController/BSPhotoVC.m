//
//  BSPhotoVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/4.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSPhotoVC.h"
#import <Masonry.h>
#import <UIView+BSView.h>

#import <BSPhotoManagerController.h>
#import "BSPhotoProtocal.h"


@interface BSPhotoVC ()<BSPhotoProtocal>

@property (nonatomic ,strong) UIButton *cameraBtn;
@property (nonatomic ,strong) UIImageView *imageView;

@end



@implementation BSPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initSubViews];
    [self masonryLayout];
}

-(void)initSubViews{

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.imageView];
}


-(void)masonryLayout{

    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(150);
        make.left.offset(80);
        make.right.offset(-80);
        make.height.mas_equalTo(45);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraBtn.mas_bottom).offset(50);
        make.left.offset(80);
        make.right.offset(-80);
        make.bottom.offset(80);
    }];

}


-(void)cameraBtnClick{

    BSPhotoManagerController *managerVC = [[BSPhotoManagerController alloc]init];
    managerVC.autoPush = YES;
//    managerVC.delegate = self;
    managerVC.modalPresentationStyle = 0;
    [self presentViewController:managerVC animated:YES completion:nil];
}


-(UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc]init];
        _cameraBtn.backgroundColor = [UIColor blueColor];
        [_cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}


@end

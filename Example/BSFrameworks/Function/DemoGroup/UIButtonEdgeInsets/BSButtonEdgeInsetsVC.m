//
//  BSButtonEdgeInsetsVC.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/30.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSButtonEdgeInsetsVC.h"
#import <UIView+BSView.h>
#import <Masonry/Masonry.h>

@class Test;
@interface BSButtonEdgeInsetsVC ()

@property (nonatomic ,strong) Test *test;

@end

@implementation BSButtonEdgeInsetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self setUpLayout];
    
//    self.test = [[Test alloc]init];
    
    self.test.testBlock = ^{
        NSLog(@"%@",@"haha");
    };
    
    self.test.testBlock();

}

#pragma mark - 布局


/**
 * UIEdgeInsetsMake(上, 左, 下, 右)
 * 偏移参照物为自己，初始偏移量是0
 * 偏移量计算公式：
 * offsetX = (左-右)/2 ,为正 则向右偏移，为负责向左偏移
 * offsetY = (上-下)/2 ,为正 则向下偏移，为负责向上偏移
 *
 * 最终偏移量是根据最终算出来的数值决定 (offsetX,offsetY)
 */

-(void)setUpSubViews{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"居左button" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.right.offset(-100);
        make.top.offset(STATUSNAVIBAR_HEIGHT + 100);
        make.height.mas_equalTo(80);
    }];
    
    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.backgroundColor = [UIColor lightGrayColor];
    [btn1 setTitle:@"居右button" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.right.offset(-100);
        make.top.equalTo(btn.mas_bottom).offset(50);
        make.height.mas_equalTo(80);
    }];
    
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.backgroundColor = [UIColor lightGrayColor];
    [btn2 setTitle:@"左上button" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.right.offset(-100);
        make.top.equalTo(btn1.mas_bottom).offset(50);
        make.height.mas_equalTo(80);
    }];
    
    
    UIButton *btn3 = [[UIButton alloc]init];
    btn3.backgroundColor = [UIColor lightGrayColor];
    [btn3 setTitle:@"右下button" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.right.offset(-100);
        make.top.equalTo(btn2.mas_bottom).offset(50);
        make.height.mas_equalTo(80);
    }];
    
    
    UIButton *btn4 = [[UIButton alloc]init];
    btn4.backgroundColor = [UIColor lightGrayColor];
//    [btn4 setTitle:@"带图IMAGE" forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.right.offset(-100);
        make.top.equalTo(btn3.mas_bottom).offset(50);
        make.height.mas_equalTo(80);
    }];
    

    ///===================================///
    ///============开始测试偏移量===========///
    ///===================================///
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
    
    //图片文字宽度
    CGFloat textW = btn.titleLabel.intrinsicContentSize.width;
    CGFloat btnW = btn.width;
    CGFloat offsetX = (btnW - textW)/2;
    
    //图片文字高度
    CGFloat textH = btn.titleLabel.intrinsicContentSize.height;
    CGFloat btnH = btn.height;
    CGFloat offsetY = (btnH - textH)/2;
    
    
    /// 偏移量计算：(0-offsetX * 2)/2 = -offsetX
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, offsetX * 2)];
    
    ///常规对称写法：数值相同，一正一负
//    /// 偏移量计算：(offsetX- (-offsetX))/2 = offsetX
//    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, offsetX, 0, -offsetX)];
    
    /// 非对称数值测试
    /// 偏移量计算：((offsetX+20) - (-offsetX + 20))/2 = offsetX
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(10, -1000, 2, -1000-offsetX*2)];
    
    [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, offsetY * 2, offsetX * 2)];
    [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(offsetY, offsetX, -offsetY, -offsetX)];
    
//    CGFloat imgW = btn4.imageView.intrinsicContentSize.width;
//    CGFloat textW1 = btn4.titleLabel.intrinsicContentSize.width;
    
    /// 图文：设置文字图片调换位置，且图片文字间隔 10 个点
//    [btn4 setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imgW + 5)*2, 0, 0)];
//    [btn4 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,  -(textW1 + 5)*2)];
    [btn4 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];

}


-(void)setUpLayout{
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




@implementation Test



@end

//
//  BSChainSuperView.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSChainSuperView.h"
#import <UIView+BSView.h>

@implementation BSChainSuperView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}


-(void)initSubView{
    
    UIButton *subView = [[UIButton alloc]init];
    subView.backgroundColor = [UIColor blueColor];
    [subView addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:subView];
    
    
    UIView *subView1 = [[UIView alloc]init];
    subView1.backgroundColor = [UIColor greenColor];
    [self addSubview:subView1];
    
    
    UILabel *subView2 = [[UILabel alloc]init];
    subView2.backgroundColor = [UIColor yellowColor];
    subView2.userInteractionEnabled = YES;
    [self addSubview:subView2];
    
    
    subView.frame = CGRectMake(0, 0, 100, 100);
    subView.center = self.center;
    
    
    subView1.frame = CGRectMake(0, 0, 80, 80);
    subView1.top = subView.bottom + 20;
    subView1.centerX = subView.centerX;
    
    
    subView2.frame = CGRectMake(0, 0, 60, 60);
    subView2.top = subView1.bottom + 20;
    subView2.centerX = subView1.centerX;
    
}


-(void)btnClicked{
    
    
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *touchView = [super hitTest:point withEvent:event];
    NSLog(@"hitTest:%@",[touchView class]);
    return touchView;
}



@end

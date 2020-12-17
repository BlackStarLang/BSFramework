//
//  BSTransitionController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/26.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSTransitionController.h"
#import "BSATransitionController.h"
#import "BSProtocalController.h"

@interface BSTransitionController ()

@property (nonatomic ,strong) UIView *greenView;
@property (nonatomic ,strong) UIView *orangeView;


@end

@implementation BSTransitionController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSubView];
}


-(void)initSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.greenView];

    self.greenView.frame = self.view.bounds;
    self.orangeView.frame = self.view.bounds;

    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    button.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [button setTitle:@"点我翻页" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(transitionAnimate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    button1.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    [button1 setTitle:@"点我跳转" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(pushTransition:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}


-(void)transitionAnimate:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    ///   跳转样式枚举
    //    UIViewAnimationOptionTransitionNone            = 0 << 20, // default
    //    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
    //    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
    //    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
    //    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
    //    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
    //    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
    //    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
    
    if (!sender.selected) {
        
        [UIView transitionFromView:self.orangeView toView:self.greenView duration:1 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
                    
            if (finished) {
                [self.orangeView removeFromSuperview];
            }
        }];
        [self.view addSubview:self.greenView];
        [self.view sendSubviewToBack:self.greenView];
        
    }else{
        
        [UIView transitionFromView:self.greenView toView:self.orangeView duration:1 options:UIViewAnimationOptionTransitionCurlDown completion:^(BOOL finished) {
                    
            if (finished) {
                [self.greenView removeFromSuperview];
            }
        }];
        [self.view addSubview:self.orangeView];
        [self.view sendSubviewToBack:self.orangeView];
    }
    
}


-(void)pushTransition:(UIButton *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    
//    BSATransitionController *aVC = [[BSATransitionController alloc]initWithAlertTitle:@"title" message:@"message" delegate:self];
//
//    [self presentViewController:aVC animated:YES completion:nil];
}



#pragma mark - init 属性初始化

-(UIView *)greenView{
    if (!_greenView) {
        _greenView = [[UIView alloc]init];
        _greenView.backgroundColor = [UIColor greenColor];
    }
    
    return _greenView;
}

-(UIView *)orangeView{
    if (!_orangeView) {
        _orangeView = [[UIView alloc]init];
        _orangeView.backgroundColor = [UIColor orangeColor];
    }
    
    return _orangeView;
}

@end

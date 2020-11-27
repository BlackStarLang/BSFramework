//
//  BSTransitionController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/26.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSTransitionController.h"
#import "BSATransitionController.h"

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
    
    BSATransitionController *aVC = [[BSATransitionController alloc]init];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:aVC];
//    nav.navigationBarHidden = YES;
//    nav.modalPresentationStyle = UIModalPresentationCurrentContext;
//    nav.modalTransitionStyle = 2;
    
//    aVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    [self.navigationController pushViewController:aVC animated:YES];
    [self presentViewController:aVC animated:YES completion:nil];

//    NSLog(@"presenting :%@",self.presentingViewController);
//    NSLog(@"presented :%@",self.presentedViewController);
//    NSLog(@"%@",self.parentViewController);
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

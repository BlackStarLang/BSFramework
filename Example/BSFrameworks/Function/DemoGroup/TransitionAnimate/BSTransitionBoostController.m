//
//  BSTransitionBoostController.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/23.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSTransitionBoostController.h"
#import "BSTransitionBoostAnimator.h"

@interface BSTransitionBoostController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic , strong) UIButton *backBtn;
@end

@implementation BSTransitionBoostController


-(instancetype)initWithBoostView:(UIView *)boostView presentViewController:(nonnull UIViewController *)presentViewController{
    
    self = [super init];
    
    if (self) {
        self.transitioningDelegate = self;
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    button.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [button setTitle:@"点我返回" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = button;
    [self.view addSubview:button];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{

    return [BSTransitionBoostAnimator new];
}



-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{


    return [BSTransitionBoostAnimator new];
}






@end

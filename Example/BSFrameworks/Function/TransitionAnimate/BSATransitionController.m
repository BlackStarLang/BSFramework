//
//  BSATransitionController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/26.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSATransitionController.h"
#import "BSProtocalController.h"

@interface BSATransitionController ()

@property (nonatomic ,strong) BSProtocalController *protocalVC;

@end

@implementation BSATransitionController

-(void)dealloc{
    NSLog(@"BSATransitionController dealloc");
}

-(instancetype)initWithAlertTitle:(NSString *)title message:(NSString *)message delegate:(nonnull UIViewController *)delegate{
    
    self = [super init];
    if (self) {
        
        BSProtocalController *protocalVC = [[BSProtocalController alloc] initWithPresentedViewController:self presentingViewController:delegate];
        self.transitioningDelegate = protocalVC;
        self.preferredContentSize = CGSizeMake(10, 300);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    button.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [button setTitle:@"点我退出" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}


-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end

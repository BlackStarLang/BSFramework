//
//  BSATransitionController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/26.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSATransitionController.h"


@interface BSATransitionController ()

@end

@implementation BSATransitionController

-(void)dealloc{
    NSLog(@"BSATransitionController dealloc");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

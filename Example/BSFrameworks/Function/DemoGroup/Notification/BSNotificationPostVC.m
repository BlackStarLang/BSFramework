//
//  BSNotificationPostVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSNotificationPostVC.h"
#import <UIView+BSView.h>
#import "BSNotificationVC.h"

@interface BSNotificationPostVC ()

@end


@implementation BSNotificationPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}


-(void)initView{
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"push to vc" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = CGPointMake(self.view.centerX, self.view.centerY - 120);
    
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"post noti" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 100, 50);
    btn1.center = self.view.center;
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(postNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}



-(void)pushVC{
    
    BSNotificationVC *notiVC = [[BSNotificationVC alloc]init];
    [self.navigationController pushViewController:notiVC animated:YES];
}



-(void)postNoti{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"objNoti" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"vcNoti" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viewNoti" object:nil];

}

@end

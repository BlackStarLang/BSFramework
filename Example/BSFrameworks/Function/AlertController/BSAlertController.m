//
//  BSAlertController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/27.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSAlertController.h"

@interface BSAlertController ()

@end

@implementation BSAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    button.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [button setTitle:@"点我弹框" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}



-(void)alert{

    [self presentAlertNomal];
}



-(void)presentAlertNomal{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"这是一个 alert 测试，如何自定义一个alert？" preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    NSLog(@"%ld",(long)alertVC.modalPresentationStyle);
    NSLog(@"%ld",(long)alertVC.modalTransitionStyle);
    NSLog(@"%@",alertVC.navigationController);
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end

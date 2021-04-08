//
//  BSResponseChainVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSResponseChainVC.h"
#import "BSChainSuperView.h"

@interface BSResponseChainVC ()

@end

@implementation BSResponseChainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    BSChainSuperView *chainView = [[BSChainSuperView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:chainView];
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

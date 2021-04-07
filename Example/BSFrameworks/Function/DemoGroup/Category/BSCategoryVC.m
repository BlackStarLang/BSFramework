//
//  BSCategoryVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryVC.h"
#import "BSCategoryOrigin.h"
#import "BSCategoryOrigin+Mutimethod.h"

@interface BSCategoryVC ()

@end

@implementation BSCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showMethod];
}


-(void)showMethod{
    
    BSCategoryOrigin *origin = [[BSCategoryOrigin alloc]init];
    [origin showTotalInfo];
//    [origin test];
    
    
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

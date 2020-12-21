//
//  BSCalculationRoot.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/21.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSCalculationRoot.h"
#import "BSHuiwenStr.h"

@interface BSCalculationRoot ()

@end

@implementation BSCalculationRoot

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"算法集锦";
    // Do any additional setup after loading the view.

    
    [self huiwenStr];
   
}


-(void)huiwenStr{
    
    NSString *rangeStr = @"jalsdfkkkakkdalajdkfkakdkd";
    
    BSHuiwenStr *huiwen = [[BSHuiwenStr alloc]init];
    BOOL hasHuiwen = [huiwen isHuiwenWithStr:rangeStr];
    NSLog(@"%@",hasHuiwen?@"有回文字符串":@"无回文字符串");
}



@end

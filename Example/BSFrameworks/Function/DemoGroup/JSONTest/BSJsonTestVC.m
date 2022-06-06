//
//  BSJsonTestVC.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/12/21.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSJsonTestVC.h"

@interface BSJsonTestVC ()

@end

@implementation BSJsonTestVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(jsonPrint) forControlEvents:UIControlEventTouchUpInside];
}


-(void)jsonPrint{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"testjson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
     
    if (jsonData) {
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
       
        NSLog(@"%@",error);

        NSLog(@"json:%ld \n dic:%@",jsonData.length,jsonDic);
    }

}


@end

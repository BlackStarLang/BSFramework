//
//  BSSocketViewController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/30.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSSocketViewController.h"
//#import <BSSocket.h>
//#import <BSSocketManager.h>

@interface BSSocketViewController ()//<BSSocketProtocal>

//@property (nonatomic ,strong) BSSocketManager *manager;
@end

@implementation BSSocketViewController

//-(void)dealloc{
//
//    [[BSSocketManager shareManager]disConnect];
//    [self.manager disConnect];
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self initView];
//    [self initSocket];
//}
//
//-(void)initView{
//
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 60)];
//    button.backgroundColor = [UIColor blueColor];
//    [button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//
//
//    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 400, 100, 60)];
//    button1.backgroundColor = [UIColor blueColor];
//    [button1 addTarget:self action:@selector(sendMessage1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
//}
//
//
//-(void)initSocket{
//    [BSSocketManager shareManager].delegate = self;
//    [[BSSocketManager shareManager]connect];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        self.manager = [[BSSocketManager alloc]init];
//        self.manager.delegate = self;
//        [self.manager connect];
//    });
//
//}
//
//
//-(void)sendMessage{
//
//    [[BSSocketManager shareManager]sendMessage:@"大家好,这里是 socket"];
//}
//
//-(void)sendMessage1{
//
//    [self.manager sendMessage:@"这是 socket 2"];
//}
//
//
//-(void)receiveMessage:(NSString *)message{
//
//    NSLog(@"receiveMessage:%@",message);
//}


@end

//
//  BSNotificationVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSNotificationVC.h"
#import "BSNotificationObj.h"
#import "BSNotificationView.h"
#import "NSNotificationCenter+BSNotiCenter.h"

@interface BSNotificationVC ()

@property (nonatomic ,strong)NSObject *tempObj;

@end

@implementation BSNotificationVC

-(void)dealloc{
    NSLog(@"dealloc");
    
    /// 如果是通知的Observer是self， 在 dealloc 中发送通知是无效的，
    /// 可以放在 didDidsappear 中，如果是self的一个属性，
    /// 比如 tempObj，是可以在dealloc中发送通知的
    [self postNoti];
    
    /// 多次移除同一个 noti 是没有问题的
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"vcNoti" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"vcNoti" object:nil];

    /// 在 VC 中，对于通知的移除是做了特殊处理的，VC的dealloc 执行完，会主动帮我们移除掉 通知，通过创建通知的分类，重写通知的 removeObserver:方法 即可验证
    /// 但是除了VC，对于Obj、view 这些对象来说，是不会主动做移除的。

    /// 在 iOS9 之前，对于没移除的通知，发送消息后，可能会导致野指针闪退问题，但是iOS 9 以后，使用了weak 对通知进行了优化（9之前使用的是 unsafe_unretained），在对象销毁后，会将指针置空，不会造成野指针
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initObjForNoti];
    [self initView];
}

-(void)initView{
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"post noti" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 100, 50);
    btn1.center = self.view.center;
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(postNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}


-(void)initObjForNoti{
    /// 本类的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(vcNoti) name:@"vcNoti" object:nil];

    /// view的通知
    BSNotificationView *view = [[BSNotificationView alloc]init];
    
    /// object的通知
    BSNotificationObj *obj = [[BSNotificationObj alloc]init];

    self.tempObj = view;
}


-(void)vcNoti{
    
    NSLog(@"vcNoti: %@",[NSThread currentThread]);
}


-(void)postNoti{
    
    /// 通过不同线程 postNoti ，证明执行消息取决于发送所在的线程
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"vcNoti" object:nil];
    });
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"objNoti" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viewNoti" object:nil];
}

@end

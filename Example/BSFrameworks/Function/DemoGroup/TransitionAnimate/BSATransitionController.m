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
        self.protocalVC = [[BSProtocalController alloc] initWithPresentedViewController:self presentingViewController:delegate title:title descreption:message];
        self.protocalVC.isAlert = YES;
        self.transitioningDelegate = self.protocalVC;
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.protocalVC = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end

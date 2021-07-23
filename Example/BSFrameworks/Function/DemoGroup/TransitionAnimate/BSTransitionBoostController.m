//
//  BSTransitionBoostController.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/23.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSTransitionBoostController.h"
#import "BSBoostPresentationVC.h"

@interface BSTransitionBoostController ()<BSBoostPresentationVCDelegate>

@property (nonatomic , strong) UIView *boostView;

@property (nonatomic ,strong) BSBoostPresentationVC *protocalVC;

@end

@implementation BSTransitionBoostController


-(instancetype)initWithBoostView:(UIView *)boostView presentViewController:(nonnull UIViewController *)presentViewController{
    
    self = [super init];
    
    if (self) {
        self.boostView = boostView;
        
        self.protocalVC = [[BSBoostPresentationVC alloc] initWithPresentedViewController:self presentingViewController:presentViewController fromView:self.boostView];
        self.protocalVC.presentDelegate = self;
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

-(void)BSBoostPresentationVCBack{
    
    [self pop];
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

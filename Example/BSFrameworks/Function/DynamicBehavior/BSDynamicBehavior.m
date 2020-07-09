//
//  BSDynamicBehavior.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/25.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSDynamicBehavior.h"

@interface BSDynamicBehavior ()

@property (nonatomic ,strong) UIDynamicAnimator *animator;
@property (nonatomic ,strong) UIAttachmentBehavior *attBehavior;


// 吸附
@property (nonatomic ,strong) UIView *redView;
@property (nonatomic ,strong) UIView *dynbItem;
@property (nonatomic ,strong) UIView *pointView;


@end

@implementation BSDynamicBehavior

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self attachment];
    // Do any additional setup after loading the view.
}


//吸附行为
-(void)attachment{
    
    [self.view addSubview:self.pointView];
    [self.view addSubview:self.dynbItem];
    [self.dynbItem addSubview:self.redView];

    self.pointView.frame = CGRectMake(50, 100, 20, 20);
    self.redView.frame = CGRectMake(20, 20, 20, 20);
    self.dynbItem.frame = CGRectMake(150, 200, 100, 100);
    
//    self.attBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.dynbItem offsetFromCenter:UIOffsetMake(-25, -25) attachedToAnchor:self.pointView.frame.origin];

    self.attBehavior = [UIAttachmentBehavior pinAttachmentWithItem:self.dynbItem attachedToItem:self.pointView attachmentAnchor:CGPointMake(200, 100)];
    
    [self.animator addBehavior:self.attBehavior];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    [self.view addGestureRecognizer:pan];
}

-(void)panAction:(UIGestureRecognizer *)sender{
    
//    self.pointView.center = [sender locationInView:self.view];
    [self.attBehavior setAnchorPoint:[sender locationInView:self.view]];
//    self.pointView.center = self.attBehavior.anchorPoint;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
}


-(UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc]init];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}



-(UIView *)dynbItem{
    if (!_dynbItem) {
        _dynbItem = [[UIView alloc]init];
        _dynbItem.backgroundColor = [UIColor blackColor];
    }
    return _dynbItem;
}

-(UIView *)pointView{
    if (!_pointView) {
        _pointView = [[UIView alloc]init];
        _pointView.backgroundColor = [UIColor grayColor];
    }
    return _pointView;
}

@end

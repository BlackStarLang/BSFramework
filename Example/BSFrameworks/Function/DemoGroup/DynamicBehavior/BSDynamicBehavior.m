//
//  BSDynamicBehavior.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/25.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSDynamicBehavior.h"
#import <UIView+BSView.h>

@interface BSDynamicBehavior ()

@property (nonatomic ,strong) UIDynamicAnimator *animator;
@property (nonatomic ,strong) UIAttachmentBehavior *attBehavior;
@property (nonatomic ,strong) UIPushBehavior *pushBehavior;

// 吸附
@property (nonatomic ,strong) UIView *redView;
@property (nonatomic ,strong) UIView *dynbItem;
@property (nonatomic ,strong) UIView *pointView;


@end

@implementation BSDynamicBehavior

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
//    [self attachment];
    [self gravityBehavior];
    [self collistionBehavior];
//    [self pushBehaviorAction];
}


-(void)initView{
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.pointView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 80.0f);
    self.pointView.backgroundColor = [UIColor greenColor];
    self.pointView.center = self.view.center;
    [self.view addSubview:self.pointView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 300)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.userInteractionEnabled = NO;
    [self.view addSubview:label];

    label.text = @"碰撞行为测试需要同时打开 gravityBehavior 和 collistionBehavior 方法进行测试\n\npushBehaviorAction 推动行为也含有碰撞行为的联合使用。\n\n在测试推动行为时，需要拖动绿色方块并松手才会生效\n\n碰撞行为可以使用贝塞尔曲线规划路径";
}


#pragma mark - 行为测试
//吸附行为
-(void)attachment{
    
    [self.view addSubview:self.pointView];
    [self.view addSubview:self.dynbItem];
    [self.dynbItem addSubview:self.redView];

    self.pointView.frame = CGRectMake(50, 100, 20, 20);
    self.redView.frame = CGRectMake(20, 20, 20, 20);
    self.dynbItem.frame = CGRectMake(150, 200, 100, 100);
    
    self.attBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.dynbItem offsetFromCenter:UIOffsetMake(-25, -25) attachedToAnchor:self.pointView.frame.origin];
    
    [self.animator addBehavior:self.attBehavior];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
}



-(void)panAction:(UIGestureRecognizer *)sender{
    
    [self.attBehavior setAnchorPoint:[sender locationInView:self.view]];
    self.pointView.center = [sender locationInView:self.view];

}



-(void)gravityBehavior{
    
    self.pointView.frame = CGRectMake(50, 100, 20, 20);
    self.pointView.centerX = self.view.centerX;
    [self.view addSubview:self.pointView];
    
    UIDynamicItemBehavior *dyItemB = [[UIDynamicItemBehavior alloc]initWithItems:@[self.pointView]];
    dyItemB.elasticity = 0.7;
    dyItemB.resistance = 0.9;
    [self.animator addBehavior:dyItemB];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.pointView]];
    gravityBehavior.gravityDirection = CGVectorMake(0.0, 1.0);
    gravityBehavior.magnitude = 0.9;

    [self.animator addBehavior:gravityBehavior];
    
}



-(void)collistionBehavior{
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.pointView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;

    [self.animator addBehavior:collisionBehavior];
}



-(void)pushBehaviorAction{
    

    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.pointView] mode:UIPushBehaviorModeInstantaneous];
    [self.animator addBehavior:pushBehavior];
    self.pushBehavior = pushBehavior;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];

    [self.pointView addGestureRecognizer:pan];
}



- (void)pan:(UIPanGestureRecognizer *)paramTap{
    
    if (paramTap.state == UIGestureRecognizerStateBegan) {
        
        
    }else if (paramTap.state == UIGestureRecognizerStateEnded) {
        
        self.pushBehavior.active = YES;

        CGPoint tapPoint = [paramTap locationInView:self.view];  //p2
        CGPoint squareViewCenterPoint = self.pointView.center;  //p1

        CGFloat deltaX = tapPoint.x - squareViewCenterPoint.x;
        CGFloat deltaY = tapPoint.y - squareViewCenterPoint.y;
        CGFloat angle = atan2(deltaY, deltaX);
        [self.pushBehavior setAngle:angle];  //推移的角度

        //勾股
        CGFloat distanceBetweenPoints =
        sqrt(pow(tapPoint.x - squareViewCenterPoint.x, 2.0) +
             pow(tapPoint.y - squareViewCenterPoint.y, 2.0));
        //double pow(double x, double y）;计算以x为底数的y次幂
        //double sqrt (double);开平方
        
        [self.pushBehavior setMagnitude:distanceBetweenPoints / 200.0f]; //推力的大小（移动速度）
        //每1个magnigude将会引起100/平方秒的加速度，这里分母越大，速度越小

            
        // 碰撞行为，设置当前视图边界为碰撞边界
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.pointView]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(STATUSNAVIBAR_HEIGHT, 0, 0, 0 )];
        [self.animator addBehavior:collisionBehavior];
    }
    

}



#pragma mark - init 属性初始化



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

//
//  BSSecondController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/5/25.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSSecondController.h"
#import "BSLooperView.h"
#import "BSCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+BSView.h"

@interface BSSecondController ()<BSLooperViewDelegate>

@property (nonatomic ,strong) BSLooperView *looperView;

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation BSSecondController

-(void)dealloc{
    
    NSLog(@"BSSecondController 释放");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addLooperView];
    
//    [self addAnimate];
    
//    [self transitionAnimate];
}

-(void)addAnimate{
    
    self.imageView.frame = CGRectMake(0, 0, 50, 50);
    NSString *url = @"https://pics6.baidu.com/feed/0dd7912397dda144302b8277f02262a40df48675.jpeg?token=0f893277230d6dbe88ac6ed35e0be20d";
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [self drawPath];
}

-(void)drawPath{
    
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.view.center.x-100, self.view.center.y-100, 200, 200) cornerRadius:80];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat tempX = 60;
        
    [path moveToPoint:CGPointMake(50, 300)];
    [path addCurveToPoint:CGPointMake(self.view.width-50, 300) controlPoint1:CGPointMake(tempX, 100) controlPoint2:CGPointMake(self.view.width-tempX, 500)];
    [path addCurveToPoint:CGPointMake(50, 300) controlPoint1:CGPointMake(self.view.width-tempX, 100) controlPoint2:CGPointMake(tempX, 500)];
    
    

    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.lineDashPattern = @[@(6),@(3)];
    layer.strokeColor = [UIColor blueColor].CGColor;
    layer.path = path.CGPath;
    
    [self.view.layer addSublayer:layer];
    
    
    
    NSArray *timingFunction = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //在动画设置一些变量
    pathAnimation.calculationMode = kCAAnimationPaced;
    //我们希望动画持续
    //如果我们动画从左到右的东西——我们想要呆在新位置,
    //然后我们需要这些参数
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 5;//完成动画的时间
//    pathAnimation.autoreverses = YES;
    //让循环连续演示
    pathAnimation.repeatCount = MAXFLOAT;
    
    pathAnimation.keyTimes = @[@(2),@(3)];
    pathAnimation.timingFunctions = timingFunction;
//    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    //现在我们的路径,我们告诉动画我们想使用这条路径,那么我们发布的路径
    pathAnimation.path = path.CGPath;

    [self.view addSubview:self.imageView];
    //添加动画circleView——一旦你添加动画层,动画开始
    [self.imageView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    
}


-(void)transitionAnimate{
    

    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(50, 300, 300, 300)];
//    bgView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:bgView];
//
//    CATransition *trans = [CATransition animation];
//    trans.type = @"oglFlip";
//    trans.startProgress = 0;
//    trans.endProgress = 1;
//    trans.subtype = kCATransitionFromTop;
//    trans.repeatCount = 10;
//    trans.duration = 1.5;
//    [bgView.layer addAnimation:trans forKey:@"11"];
}


-(void)addLooperView{
    
    self.looperView = [[BSLooperView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 300)];
    self.looperView.cellName = @"BSCollectionViewCell";
    self.looperView.delegate = self;
    self.looperView.isInfinite = YES;
    self.looperView.itemSize = CGSizeMake(self.view.width - 80, 300);
    self.looperView.minimumLineSpacing = 10;
    
    NSString *url = @"https://pics6.baidu.com/feed/0dd7912397dda144302b8277f02262a40df48675.jpeg?token=0f893277230d6dbe88ac6ed35e0be20d";
    NSString *url1 = @"https://pics0.baidu.com/feed/8b82b9014a90f60375143a228c59041db151ed85.jpeg?token=bf540b320d9f8fe20b306f4a0f863378";
    NSString *url2 = @"https://wenhui.whb.cn/u/cms/www/202005/251008229olq.png";
    NSString *url3 = @"https://pics5.baidu.com/feed/5fdf8db1cb13495446f2bdd96d87245ed3094aea.jpeg?token=4a4ada5a734da5504dfb371cd74ecf78";

    self.looperView.dataArr = @[url,url1,url2,url3];
    [self.view addSubview:self.looperView];

}


-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell cellForModel:(id)model{
    
    BSCollectionViewCell *bsCell = (BSCollectionViewCell *)cell;

    [bsCell.cellImageView sd_setImageWithURL:[NSURL URLWithString:model]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - init 属性初始化

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

@end

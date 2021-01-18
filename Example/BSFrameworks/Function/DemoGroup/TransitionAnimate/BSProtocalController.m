
#define CORNER_RADIUS   4.f //16.f
#define ALERT_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define ALERT_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define ALERT_FRAME CGRectMake(ALERT_SCREEN_W * 0.15, ALERT_SCREEN_H * 0.3, ALERT_SCREEN_W * 0.7, ALERT_SCREEN_H * 0.4);

#import "BSProtocalController.h"
#import <UIView+BSView.h>

@interface BSProtocalController()<UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationWrappingView;

@property (nonatomic ,assign) CGRect alertFrame;

@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *descreptionStr;


@end

@implementation BSProtocalController



-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController title:(NSString *)title descreption:(NSString *)descreption{
    
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        self.alertFrame = ALERT_FRAME;
        self.title = title;
        self.descreptionStr = descreption;
    }
    
    return self;
}




- (UIView*)presentedView{
    
    return self.presentationWrappingView;
}



- (void)presentationTransitionWillBegin{
    
    [self addContainerWrapView];
    
    [self addDimmingView];
    
    [self addSubViews];
}



-(void)addContainerWrapView{
    
    UIView *presentedControllerView = [super presentedView];
    
    UIView *presentationWrapperView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
    presentationWrapperView.layer.shadowOpacity = 0.2f;
    presentationWrapperView.layer.shadowRadius = CORNER_RADIUS;
    presentationWrapperView.layer.shadowOffset = CGSizeMake(0, -3.f);
    self.presentationWrappingView = presentationWrapperView;
    
    
    UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, -CORNER_RADIUS, 0))];
    presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    presentationRoundedCornerView.layer.cornerRadius = CORNER_RADIUS;
    presentationRoundedCornerView.layer.masksToBounds = YES;
    
    
    UIView *presentedControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, self.isAlert?0:CORNER_RADIUS, 0))];
    presentedControllerWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    /// 添加各种子view
    // Add presentedViewControllerWrapperView.
    presentedControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    presentedControllerView.frame = presentedControllerWrapperView.bounds;
  
    [presentedControllerWrapperView addSubview:presentedControllerView];
    [presentationRoundedCornerView addSubview:presentedControllerWrapperView];
    [presentationWrapperView addSubview:presentationRoundedCornerView];
}



-(void)addDimmingView{
    /// 做屏幕透明度
    UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.opaque = NO;
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    self.dimmingView = dimmingView;
    [self.containerView addSubview:dimmingView];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.3f;
    } completion:NULL];
}



-(void)addSubViews{
    
    CGRect alertFrame = ALERT_FRAME;
 
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, alertFrame.size.width - 30, 0)];
    title.text = self.title;
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:16];
    [title sizeToFit];
    title.centerX = alertFrame.size.width/2;
    
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(title.left, title.bottom + 10, alertFrame.size.width - 30, 0)];
    desLabel.text = self.descreptionStr;
    desLabel.font = [UIFont systemFontOfSize:15];
    desLabel.numberOfLines = 0;
    desLabel.textAlignment = NSTextAlignmentCenter;
    [desLabel sizeToFit];
    desLabel.centerX = alertFrame.size.width/2;
    

    
    UIStackView *buttonContainer = [[UIStackView alloc]initWithFrame:CGRectMake(0, desLabel.bottom + 10, self.alertFrame.size.width, 40)];
   
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [buttonContainer addArrangedSubview:sureBtn];
    [buttonContainer addArrangedSubview:cancelBtn];
    buttonContainer.distribution = UIStackViewDistributionFillEqually;
    
    [self.presentationWrappingView addSubview:title];
    [self.presentationWrappingView addSubview:desLabel];
    [self.presentationWrappingView addSubview:buttonContainer];
    
    CGFloat left = (SCREEN_WIDTH - self.alertFrame.size.width)/2;
    CGFloat top = (SCREEN_HEIGHT - buttonContainer.bottom)/2;
    self.alertFrame = CGRectMake(left, top, self.alertFrame.size.width, buttonContainer.bottom);
}


- (void)dismissalTransitionWillBegin{
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}



- (void)dismissalTransitionDidEnd:(BOOL)completed{
    
    if (completed == YES){
        
        self.presentationWrappingView = nil;
        self.dimmingView = nil;
    }
}


#pragma mark - action
-(void)buttonClick:(UIButton *)sender{
    
    
}


- (void)presentationTransitionDidEnd:(BOOL)completed{
   
    if (completed == NO){
        self.presentationWrappingView = nil;
        self.dimmingView = nil;
    }
}



#pragma mark - Layout

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container{
   
    NSLog(@"preferredContentSizeDidChangeForChildContentContainer \n");

    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController){
        [self.containerView setNeedsLayout];
    }
}


- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize{
    
    NSLog(@"sizeForChildContentContainer \n");
    
    if (container == self.presentedViewController){
        return ((UIViewController*)container).preferredContentSize;
    }else{
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}



- (CGRect)frameOfPresentedViewInContainerView{
    
    NSLog(@"frameOfPresentedViewInContainerView \n");
    return self.alertFrame;
}


- (void)containerViewWillLayoutSubviews{
    
    NSLog(@"containerViewWillLayoutSubviews \n");

    [super containerViewWillLayoutSubviews];
    
    self.dimmingView.frame = self.containerView.bounds;
    self.presentationWrappingView.frame = self.frameOfPresentedViewInContainerView;
}





#pragma mark - Tap Gesture Recognizer

- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}







#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return [transitionContext isAnimated] ? 0.35 : 0;
}




- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:toView];
    
    if (isPresenting) {
        toView.frame = self.frameOfPresentedViewInContainerView;
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    toView.alpha = 0.f;
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting){
            toView.alpha = 1.f;
        }else{
            fromView.alpha = 0.f;
        }
        
    } completion:^(BOOL finished) {
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}









#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}


@end

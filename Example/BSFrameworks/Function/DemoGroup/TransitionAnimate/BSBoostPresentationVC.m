//
//  BSBoostPresentationVC.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/23.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#define CORNER_RADIUS   4.f //16.f
#define ALERT_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define ALERT_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCRREN_FRAME CGRectMake(0, 0, ALERT_SCREEN_W, ALERT_SCREEN_H);

#import "BSBoostPresentationVC.h"

@interface BSBoostPresentationVC ()<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *boostView;
@property (nonatomic, strong) UIView *presentationWrappingView;

@property (nonatomic ,assign) CGRect boostFrame;

@end


@implementation BSBoostPresentationVC

-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView{
    
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        
        self.boostView = fromView;
        
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        CGRect boostFrame = [self.boostView convertRect:self.boostView.frame toView:keyWindow];
        self.boostFrame = boostFrame;
        
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
    
}



- (UIView*)presentedView{
    
    return self.presentationWrappingView;
}



- (void)presentationTransitionWillBegin{
    
    [self addContainerWrapView];
    
//    [self addDimmingView];
    
    [self addSubViews];
}



-(void)addContainerWrapView{
    
    UIView *presentedControllerView = [super presentedView];
    
    UIView *presentationWrapperView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
    presentationWrapperView.layer.shadowOpacity = 0.2f;
    presentationWrapperView.layer.shadowRadius = CORNER_RADIUS;
    presentationWrapperView.layer.shadowOffset = CGSizeMake(0, -3.f);
    presentationWrapperView.backgroundColor = [UIColor lightGrayColor];
    self.presentationWrappingView = presentationWrapperView;
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
//    self.presentationWrappingView.frame = self.boostFrame;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.presentationWrappingView.frame = SCRREN_FRAME;
    } completion:NULL];
    
    
    UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, -CORNER_RADIUS, 0))];
    presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    presentationRoundedCornerView.layer.cornerRadius = CORNER_RADIUS;
    presentationRoundedCornerView.layer.masksToBounds = YES;


    UIView *presentedControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, CORNER_RADIUS,0))];
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

    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.presentationWrappingView.frame = self.boostFrame;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        self.containerView.frame = keyWindow.bounds;
        self.presentationWrappingView.frame = SCRREN_FRAME;
    } completion:NULL];
}


- (void)dismissalTransitionWillBegin{
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.presentationWrappingView.frame = self.boostFrame;
        
    } completion:NULL];
}

-(void)addSubViews{
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    button2.center = CGPointMake(100, 200);
    [button2 setTitle:@"Boost" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.presentationWrappingView addSubview:button2];
    
}



- (void)dismissalTransitionDidEnd:(BOOL)completed{
    
    if (completed == YES){
        
        self.presentationWrappingView = nil;
        self.boostView = nil;
    }
}


#pragma mark - action
-(void)buttonClick:(UIButton *)sender{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];

}


- (void)presentationTransitionDidEnd:(BOOL)completed{
   
    if (completed == NO){
        self.presentationWrappingView = nil;
        self.boostView = nil;
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

    return self.boostFrame;
}


- (void)containerViewWillLayoutSubviews{
    
    NSLog(@"containerViewWillLayoutSubviews \n");

    [super containerViewWillLayoutSubviews];
    
    self.boostView.frame = self.containerView.bounds;
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

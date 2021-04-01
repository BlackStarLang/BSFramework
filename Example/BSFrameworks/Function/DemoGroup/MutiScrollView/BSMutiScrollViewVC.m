//
//  BSMutiScrollViewVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/17.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSMutiScrollViewVC.h"
#import <Masonry/Masonry.h>
#import <UIView+BSView.h>
#import "BSTapButton.h"

@interface BSMutiScrollViewVC ()

@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIScrollView *mainScrollView;
@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic ,strong) BSTapButton *talkBtn;


@end

@implementation BSMutiScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}


-(void)initView{
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.mainScrollView];
    [self.bottomView addSubview:self.scrollView];
    [self.mainScrollView addSubview:self.talkBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(400);
    }];
    
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.frame = CGRectMake(0, 0, self.view.width, 300);
    self.talkBtn.frame = CGRectMake(50, 50, self.view.width - 100, 200);
    self.scrollView.frame = CGRectMake(0, 310, self.view.width, 80);
    
    self.mainScrollView.contentSize = CGSizeMake(self.view.width *3, 300);
 
    
    
    
}


-(void)longpress:(UIGestureRecognizer *)gesture{
    
    
    
    CGPoint curPoint = [gesture locationInView:self.talkBtn];
    NSLog(@"curPoint %@",NSStringFromCGPoint(curPoint));
}







#pragma mark - init 属性初始化


-(UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    
    return _bottomView;
}

-(UIScrollView *)mainScrollView{
    
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
    }
    
    return _mainScrollView;
}



-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.backgroundColor = [UIColor blueColor];
        
    
    }
    
    return _scrollView;
}



-(BSTapButton *)talkBtn{
    
    if (!_talkBtn) {
        _talkBtn = [[BSTapButton alloc]init];
        _talkBtn.backgroundColor = [UIColor redColor];
        
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
        tap.minimumPressDuration = 1;
        [_talkBtn addGestureRecognizer:tap];
    }
    return _talkBtn;
}




@end

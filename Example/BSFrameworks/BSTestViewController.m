//
//  BSTestViewController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/3/30.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSTestViewController.h"

@interface BSTestViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic ,strong) UIScrollView *scrollView;

@end

@implementation BSTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubViews];
    [self masonryLayout];

}


-(void)initSubViews{
    
    [self.view addSubview:self.scrollView];
    
}

-(void)masonryLayout{
    
    self.scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 400);
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 400);
    
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, 400)];
        view.backgroundColor = [UIColor grayColor];
        [self.scrollView addSubview:view];
    }
}


#pragma mark - systemDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    
}

#pragma mark - init 属性初始化


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}



@end

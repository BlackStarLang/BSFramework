//
//  BSSegmentVC.m
//  BSFrameworks_Example
//
//  Created by zongheng on 2023/2/28.
//  Copyright © 2023 blackstar_lang@163.com. All rights reserved.
//

#import "BSSegmentVC.h"
#import <BSSegmentView.h>
#import <UIView+BSView.h>

@interface BSSegmentVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BSSegmentView *segmentView;
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation BSSegmentVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.dataArr = @[@"全部",@"悬疑",@"言情",@"奇幻",@"古代言情",@"现代商战",@"冒险",@"无限流",@"猎奇",@"脑洞"];
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.scrollView];
    
    self.segmentView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 44);
    self.scrollView.frame = CGRectMake(0, 144, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 144);
    
    for (int i = 0 ; i<self.dataArr.count ; i++) {
        UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
        view.left = SCREEN_WIDTH * i;
        view.backgroundColor = [UIColor colorWithRed:(arc4random()%(255))/255.0 green:(arc4random()%(255))/255.0 blue:(arc4random()%(255))/255.0 alpha:1];
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(self.dataArr.count * self.view.width, [UIScreen mainScreen].bounds.size.height - 144);
    self.segmentView.linkScrollView = self.scrollView;
    
    [self.segmentView setDataArr:self.dataArr];
}



- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (BSSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[BSSegmentView alloc]init];
        _segmentView.lineSpace = 20;
        _segmentView.normalFont = [UIFont systemFontOfSize:16];
        _segmentView.selectFont = [UIFont systemFontOfSize:21];
        _segmentView.normalColor = [UIColor blackColor];
        _segmentView.selectColor = [UIColor redColor];
        _segmentView.aligmentType = barTitleAligmentType_Bottom;
        _segmentView.verticalOffsetY = -8;
        _segmentView.headIndent = 15;
        [_segmentView setIndicatorLineColor:[UIColor cyanColor] orImage:nil];
    }
    return _segmentView;
}


@end

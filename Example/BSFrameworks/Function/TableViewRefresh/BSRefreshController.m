//
//  BSRefreshController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/11.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSRefreshController.h"
#import <UIView+BSView.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

//#import "BSRefresh.h" 


@interface BSRefreshController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataSource;
@property (nonatomic ,strong) NSAttributedString *attri;

@end



@implementation BSRefreshController

-(void)dealloc{
    NSLog(@"BSRefreshController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self masonryLayout];

}


-(void)initSubViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

   
    self.dataSource = @[@"本控件暂时搁浅，开发途中发现，无法使用几个文件撑起这么大的功能，所以暂时搁浅，对比发现 MJRefresh 基本已经很完善了，个人本来是想要学习如何制作上下拉刷新控件，并增加常用的功能，比如 预加载功能等，拜读了 MJRefresh 后，发现代码想法很棒，逻辑清晰，除个别小问题（不影响使用）外，堪称完美，但是不清楚为什么没有做预加载功能"];
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    
    self.attri = [[NSAttributedString alloc]initWithString:self.dataSource.firstObject attributes:@{NSParagraphStyleAttributeName:style}];

    
//    发现写起来有点多 - 搁浅
    
//    __weak typeof(self)weakSelf = self;
//
//    self.tableView.headerRefreshBlock = ^(UIScrollView * _Nonnull refreshView) {
//        UITableView *tableView = (UITableView *)refreshView;
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.dataSource = @[@"大家好",@"大家好2",@"大家好3",
//                                    @"大家好4",@"大家好5",@"大家好6",
//                                    @"大家好4",@"大家好11",@"======"];
//            [tableView reloadData];
//            [tableView endHeaderRefresh];
//            NSLog(@"上拉刷新");
//        });
//    };
//
//    __block int count = 0;
//    self.tableView.footerRefreshBlock = ^(UIScrollView * _Nonnull refreshView) {
//
//        UITableView *tableView = (UITableView *)refreshView;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            count ++;
//            [tableView endAllRefresh];
//
//            if (count <= 3) {
//                NSMutableArray *mut = [NSMutableArray arrayWithArray:weakSelf.dataSource];
//                for (int i = 0; i<10; i++) {
//                    [mut addObject:[NSString stringWithFormat:@"test - %d",i]];
//                }
//                weakSelf.dataSource = [mut copy];
//            }
//
//            NSLog(@"加载更多%lu",(unsigned long)weakSelf.dataSource.count);
//            [tableView reloadData];
//        });
//    };
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.dataSource = @[@"大家好",@"大家好2",@"大家好3",
//                                    @"大家好4",@"大家好5",@"大家好6",
//                                    @"大家好",@"大家好2",@"大家好3",
//                                    @"大家好4",@"大家好5",@"大家好6",
//                                    @"大家好4",@"大家好5",@"大家好6",
//                                    @"大家好4",@"大家好5",@"======"];
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView.mj_header endRefreshing];
//        });
//    }];
//
//
//
//    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            count ++;
//
//            if (count <= 3) {
//                NSMutableArray *mut = [NSMutableArray arrayWithArray:weakSelf.dataSource];
//                for (int i = 0; i<3; i++) {
//                    [mut addObject:[NSString stringWithFormat:@"test - %d",i]];
//                }
//                weakSelf.dataSource = [mut copy];
//            }
//
//            NSLog(@"加载更多%lu",(unsigned long)weakSelf.dataSource.count);
//
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView.mj_footer endRefreshing];
//        });
//
//    }];

}



-(void)masonryLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
}

#pragma mark - systemDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 280;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
    }
    
    cell.textLabel.attributedText = self.attri;
//    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}





#pragma mark - init 属性初始化

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableFooterView.height = 0.1;
//        _tableView.tableFooterView.height = BOTTOM_SAFE_MARGIN;
    }
    return _tableView;
}

@end

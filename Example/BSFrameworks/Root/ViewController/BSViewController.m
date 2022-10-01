//
//  BSViewController.m
//  BSFrameworks
//
//  Created by blackstar_lang@163.com on 03/28/2020.
//  Copyright (c) 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSViewController.h"

#import <UIImageView+WebCache.h>
#import <UIView+BSView.h>
#import <Masonry/Masonry.h>

#import "BSRootCell.h"
#import "BSFunctionModel.h"

@interface BSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) UILabel *tipLabel;

@end



@implementation BSViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self initSubViews];
    [self masonryLayout];
    [self configNavi];
}

-(void)configNavi{
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc]init];
        [appearance configureWithDefaultBackground];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

-(void)initSubViews{

    self.title = @"BSFrameWork";
    
    BSFunctionModel *functionM = [[BSFunctionModel alloc]init];
    [functionM getFunctionArr];

    self.dataSource = functionM.funcArr;

    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.tipLabel];
    self.tableView.tableHeaderView = self.headerView;
}



-(void)masonryLayout{

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.offset(0);
        make.left.offset(0);
        make.height.mas_equalTo(self.view.frame.size.height);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];
}

#pragma mark - action

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    BSFunctionItem *item = self.dataSource[indexPath.row];

    UIViewController *targetVC = [[NSClassFromString(item.pushTargetName) alloc]init];

    [self.navigationController pushViewController:targetVC animated:YES];
}



#pragma mark - tableView delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BSRootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[BSRootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];   
    }

    BSFunctionItem *item = self.dataSource[indexPath.row];

    cell.indexLabel.text = [NSString stringWithFormat:@"%ld、",(long)indexPath.row + 1];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",item.title];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self didSelectRowAtIndexPath:indexPath];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init 属性初始化

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
        title.textColor = [UIColor redColor];
        title.font = [UIFont systemFontOfSize:20];
        title.text = @"使用须知";
        title.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:title];
    }
    return _headerView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH - 40, 150)];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.text = @"** 功能说明及知识要点请看代码注释\n\n** 大部分页面都是空白的，效果都在xcode输出面板上\n\n** 部分功能需要手动调试代码";
    }
    return _tipLabel;
}

@end

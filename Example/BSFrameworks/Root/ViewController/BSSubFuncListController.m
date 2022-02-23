//
//  BSSubFuncListController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/1/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSSubFuncListController.h"
#import <UIImageView+WebCache.h>
#import <UIView+BSView.h>
#import <Masonry/Masonry.h>

#import "BSRootCell.h"
#import "BSFunctionModel.h"

@interface BSSubFuncListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation BSSubFuncListController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self initSubViews];
    [self masonryLayout];
}



-(void)initSubViews{

    self.title = @"DemoGroup";
    
    BSFunctionModel *functionM = [[BSFunctionModel alloc]init];
    [functionM getSubFuncArr];

    self.dataSource = functionM.subFuncArr;

    [self.view addSubview:self.tableView];
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


@end

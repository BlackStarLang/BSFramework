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

#import "BSFunctionModel.h"




@interface BSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation BSViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self initSubViews];
    [self masonryLayout];
}



-(void)initSubViews{

    self.title = @"BSFrameWork";

    BSFunctionModel *functionM = [[BSFunctionModel alloc]init];
    [functionM getFunctionArr];

    self.dataSource = functionM.funcArr;

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    BSFunctionItem *item = self.dataSource[indexPath.row];

    cell.textLabel.text = item.title;

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
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}


@end

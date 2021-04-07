//
//  BSChildScrollVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSChildScrollVC.h"
#import "BSRecoChildTableView.h"
#import <Masonry/Masonry.h>

@interface BSChildScrollVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) BSRecoChildTableView *tableView;

@end

@implementation BSChildScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
    [self masonryLayout];
}


-(void)initSubViews{
    
    [self.view addSubview:self.tableView];
}

-(void)masonryLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"indexPath one two three";
    
    return cell;
}





-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[BSRecoChildTableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



@end

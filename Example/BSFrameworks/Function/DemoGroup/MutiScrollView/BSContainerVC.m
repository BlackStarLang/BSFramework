//
//  BSContainerVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSContainerVC.h"
#import "BSRecoChildTableView.h"
#import "BSClassifyScrollView.h"
#import <Masonry/Masonry.h>

@interface BSContainerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) BSRecoChildTableView *tableView;

@end

@implementation BSContainerVC

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


-(void)setChildViewControllers:(NSArray *)childViewControllers{
    _childViewControllers = childViewControllers;
    
    if (childViewControllers.count<=0) return;
    
    NSMutableArray *itemTitles = [NSMutableArray array];
    
    for (UIViewController *childVC in childViewControllers) {
       
        [itemTitles addObject:childVC.title.length?childVC.title:@"无标题"];
        
        if (childVC == childViewControllers.firstObject) {
          
            [self addChildViewController:childVC];
            if (childVC.view.frame.size.height <=0) {
                childVC.view.frame = self.view.frame;
            }
            [self.view addSubview:childVC.view];
        }
    }
    
    [self.classifyScrollView setItemsTitle:[itemTitles copy]];
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.frame.size.height;
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

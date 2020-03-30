//
//  BSPhotoGroupController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import "BSPhotoGroupController.h"
#import "BSPhotoDataManager.h"
#import <Masonry/Masonry.h>
#import "PhotoGroupListCell.h"
#import <Photos/Photos.h>
#import "BSPhotoGroupModel.h"
#import "BSPhotoViewModel.h"
#import "BSPhotoListController.h"

@interface BSPhotoGroupController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,copy) NSMutableArray *dataSource;

@end

@implementation BSPhotoGroupController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:@"我的相册"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    [self masonryLayout];
    [self configData];
    [self getAllGroupList];

}

-(void)initSubViews{
    
    self.title = @"我的相册";

    self.navigationController.navigationBar.topItem.title = @"";
    
    [self.view addSubview:self.tableView];
    
}

-(void)masonryLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}

-(void)configData{
    
    [self.tableView registerClass:[PhotoGroupListCell class] forCellReuseIdentifier:@"PhotoGroupListCell"];
}



-(void)getAllGroupList{
    
    [BSPhotoDataManager getAllPhotoLibraryWithCacheCoverImageGroupList:^(NSArray *groupList) {
       
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[groupList copy]];

        [self.tableView reloadData];
    }];

}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoGroupListCell" forIndexPath:indexPath];
    
    [BSPhotoViewModel displayGroupListCell:cell groupModel:self.dataSource[indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BSPhotoListController *photoListVC = [[BSPhotoListController alloc]init];
    photoListVC.groupModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:photoListVC animated:YES];
}



#pragma mark - init 属性初始化


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

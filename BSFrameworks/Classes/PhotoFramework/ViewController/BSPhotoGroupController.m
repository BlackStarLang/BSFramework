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

@property (nonatomic ,strong) BSPhotoDataManager *dataManager;

@end

@implementation BSPhotoGroupController


-(void)dealloc{
    NSLog(@"==== %@ dealloc =====",NSStringFromClass([self class]));
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLabel.text = @"我的相册";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = 1;
    self.navigationItem.titleView = titleLabel;

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

    [self.dataManager getAllAlbumsWithType:0 albums:^(NSArray *albums) {
               
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[albums copy]];

        [self.tableView reloadData];
    }];
}


#pragma mark - action 交互事件

-(void)dismiss{

    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoGroupListCell" forIndexPath:indexPath];
    
    [BSPhotoViewModel displayGroupListCell:cell groupModel:self.dataSource[indexPath.row] dataManager:self.dataManager];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BSPhotoListController *photoListVC = [[BSPhotoListController alloc]init];
    photoListVC.groupModel = self.dataSource[indexPath.row];
    photoListVC.selectDataArr = self.selectDataArr;
    photoListVC.modalPresentationStyle = UIModalPresentationFullScreen;
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

-(BSPhotoDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[BSPhotoDataManager alloc]init];
    }
    return _dataManager;
}

@end

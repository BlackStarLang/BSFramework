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
#import <Photos/Photos.h>
#import "BSPhotoConfig.h"


@interface BSPhotoGroupController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,copy) NSMutableArray *dataSource;

@property (nonatomic ,strong) BSPhotoDataManager *dataManager;

@end

@implementation BSPhotoGroupController


-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configData];
    [self initSubViews];
    [self masonryLayout];
    [self authorization];
}

// 相册权限
-(void)authorization{
    //请求相机权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    //授权后，发送通知跳转到 图片列表页面
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"auth_img_library" object:nil];
                    [self authorization];
                }else{
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"相机权限未开启,请前往手机-设置开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [controller addAction:action];
                    [self presentViewController:controller animated:YES completion:nil];
                    return;
                }
            });
            
        }];
        
    }else if (status == AVAuthorizationStatusDenied) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"相机权限未开启,请前往手机-设置开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
        
        return;
    }else if (status == AVAuthorizationStatusAuthorized){
        
        [self getAllGroupList];
    }
}


-(void)initSubViews{
    
    self.title = @"我的相册";

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;

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

    [self.dataManager getAllAlbumsWithType:[BSPhotoConfig shareConfig].mediaType albums:^(NSArray *albums) {
               
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
    
    return (self.dataSource.count!=0)?self.dataSource.count:1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoGroupListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count) {
        [BSPhotoViewModel displayGroupListCell:cell groupModel:self.dataSource[indexPath.row] dataManager:self.dataManager];
    }else{
        [BSPhotoViewModel displayGroupListCell:cell groupModel:nil dataManager:self.dataManager];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BSPhotoListController *photoListVC = [[BSPhotoListController alloc]init];
    if (self.dataSource.count) {
        photoListVC.groupModel = self.dataSource[indexPath.row];
    }
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

//
//  BSPhotoManagerController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import "BSPhotoManagerController.h"
#import "BSPhotoGroupController.h"
#import "BSPhotoListController.h"
#import "BSPhotoDataManager.h"


@interface BSPhotoManagerController ()

@property (nonatomic ,copy) NSMutableArray *dataSource;

@property (nonatomic ,strong) BSPhotoDataManager *dataManager;

@property (nonatomic ,strong) NSMutableArray *selectDataArr;

@end

@implementation BSPhotoManagerController

-(instancetype)init{
    
    self = [super init];

    if (self) {
        
        BSPhotoGroupController *root = [[BSPhotoGroupController alloc]init];
        root.selectDataArr = self.selectDataArr;
        self = [super initWithRootViewController:root];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
    [self masonryLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)initSubViews{
    

}


-(void)masonryLayout{
    
    
}

-(void)getGroupListData{
    
    __weak typeof(self)weakSelf = self;
    [self.dataManager getPhotoLibraryGroupModel:^(BSPhotoGroupModel *groupModel) {
        
        BSPhotoListController *photoListVC = [[BSPhotoListController alloc]init];
        photoListVC.groupModel = groupModel;
        photoListVC.selectDataArr = self.selectDataArr;
        photoListVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf pushViewController:photoListVC animated:YES];
    }];
}

#pragma mark - action 交互事件




#pragma mark - set method

-(void)setAutoPush:(BOOL)autoPush{
    _autoPush = autoPush;

    if (autoPush) {
        [self getGroupListData];
    }
}


#pragma mark - systemDelegate











#pragma mark - init 属性初始化


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

-(NSMutableArray *)selectDataArr{
    if (!_selectDataArr) {
        _selectDataArr = [NSMutableArray array];
    }
    return _selectDataArr;
}

@end

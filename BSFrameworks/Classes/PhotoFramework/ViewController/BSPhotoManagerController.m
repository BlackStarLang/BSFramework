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

@property (nonatomic ,weak) BSPhotoGroupController *rootViewController;

@end

@implementation BSPhotoManagerController


#pragma mark - 生命周期

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(instancetype)init{

    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishSelectImage) name:@"didFinishSelectImage" object:nil];
        BSPhotoGroupController *root = [[BSPhotoGroupController alloc]init];
        root.selectDataArr = self.selectDataArr;
        self = [super initWithRootViewController:root];
        self.rootViewController = root;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - noti 
/// 点击完成发送通知 回调图片
-(void)didFinishSelectImage{
    
    __weak typeof(self)weakSelf = self;
    
    if ([self.BSDelegate respondsToSelector:@selector(BSPhotoManagerDidFinishedSelectImage:)]) {
        
        [self.dataManager getImagesWithLocalIdentifiers:self.selectDataArr imageType:@"UIImage" isOrigin:YES targetSize:CGSizeMake(0, 0) resultCallBack:^(NSArray *imageArr) {
            
            [weakSelf.BSDelegate BSPhotoManagerDidFinishedSelectImage:imageArr];
        }];
    }
    
    
    if ([self.BSDelegate respondsToSelector:@selector(BSPhotoManagerDidFinishedSelectImageData:)]) {
        
        [self.dataManager getImagesWithLocalIdentifiers:self.selectDataArr imageType:@"NSData" isOrigin:YES targetSize:CGSizeMake(0, 0) resultCallBack:^(NSArray *imageArr) {
            
            [weakSelf.BSDelegate BSPhotoManagerDidFinishedSelectImageData:imageArr];
        }];
    }
}


#pragma mark - set method

-(void)setAutoPush:(BOOL)autoPush{
    _autoPush = autoPush;

    if (autoPush) {
        [self getGroupListData];
    }
}

-(void)setMainColor:(UIColor *)mainColor{
    _mainColor = mainColor;
    
    self.navigationBar.barTintColor = mainColor;
    self.toolbar.barTintColor = mainColor;
    
    self.rootViewController.mainColor = mainColor;
}

#pragma mark - 数据请求

-(void)getGroupListData{
    
    __weak typeof(self)weakSelf = self;
    [self.dataManager getPhotoLibraryGroupModel:^(BSPhotoGroupModel *groupModel) {
        
        BSPhotoListController *photoListVC = [[BSPhotoListController alloc]init];
        photoListVC.groupModel = groupModel;
        photoListVC.selectDataArr = self.selectDataArr;
        photoListVC.mainColor = self.mainColor;
        photoListVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf pushViewController:photoListVC animated:YES];
    }];
}


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

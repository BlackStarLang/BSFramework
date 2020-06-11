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
#import "BSPhotoConfig.h"

@interface BSPhotoManagerController ()

@property (nonatomic ,copy) NSMutableArray *dataSource;

@property (nonatomic ,strong) NSMutableArray *selectDataArr;

@property (nonatomic ,strong) BSPhotoDataManager *dataManager;


@end

@implementation BSPhotoManagerController


#pragma mark - 生命周期

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[BSPhotoConfig shareConfig]resetAllConfig];
}


-(instancetype)init{

    self = [super init];
    
    if (self) {
                
        [BSPhotoConfig shareConfig].allowSelectMaxCount = 9;
        [BSPhotoConfig shareConfig].supCamera = YES;
        [BSPhotoConfig shareConfig].saveToAlbum = YES;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishSelectImage:) name:@"didFinishSelectImage" object:nil];
        
        BSPhotoGroupController *root = [[BSPhotoGroupController alloc]init];
        root.selectDataArr = self.selectDataArr;
        self = [super initWithRootViewController:root];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(UIStatusBarStyle)preferredStatusBarStyle{

    return [BSPhotoConfig shareConfig].barStyle;
}

#pragma mark - noti 
/// 点击完成发送通知 回调图片
-(void)didFinishSelectImage:(NSNotification*)noti{
    
    __weak typeof(self)weakSelf = self;
    
    if ([self.BSDelegate respondsToSelector:@selector(BSPhotoManagerDidFinishedSelectImage:)]) {
        
        [self.dataManager getImagesWithLocalIdentifiers:self.selectDataArr imageType:@"UIImage" isOrigin:[BSPhotoConfig shareConfig].isOrigin targetSize:CGSizeMake(0, 0) resultCallBack:^(NSArray *imageArr) {
            
            NSMutableArray *targetImgs = [NSMutableArray arrayWithArray:imageArr];
            if (noti.object && [noti.object isKindOfClass:[UIImage class]]) {
                [targetImgs addObject:noti.object];
            }
            
            [weakSelf.BSDelegate BSPhotoManagerDidFinishedSelectImage:targetImgs];
        }];
    }
    
    
    if ([self.BSDelegate respondsToSelector:@selector(BSPhotoManagerDidFinishedSelectImageData:)]) {
        
        [self.dataManager getImagesWithLocalIdentifiers:self.selectDataArr imageType:@"NSData" isOrigin:[BSPhotoConfig shareConfig].isOrigin targetSize:CGSizeMake(0, 0) resultCallBack:^(NSArray *imageArr) {
            
            NSMutableArray *targetImgs = [NSMutableArray arrayWithArray:imageArr];
            
            if (noti.object && [noti.object isKindOfClass:[UIImage class]]) {
                NSData *photoData = UIImageJPEGRepresentation(noti.object, 0.8);
                [targetImgs addObject:photoData];
            }
            
            [weakSelf.BSDelegate BSPhotoManagerDidFinishedSelectImageData:targetImgs];
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
    [BSPhotoConfig shareConfig].mainColor = mainColor;
    
    self.navigationBar.barTintColor = mainColor;
    self.toolbar.barTintColor = mainColor;
    
    if ([self isLighterColor:mainColor]) {
        self.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        [BSPhotoConfig shareConfig].barStyle = UIStatusBarStyleDefault;
    }else{
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [BSPhotoConfig shareConfig].barStyle = UIStatusBarStyleLightContent;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
/// 判断 颜色明暗
- (BOOL)isLighterColor:(UIColor *)color {
    if (!color) {
       return YES;
    }
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}


-(void)setAllowSelectMaxCount:(NSInteger)allowSelectMaxCount{
    [BSPhotoConfig shareConfig].allowSelectMaxCount = allowSelectMaxCount;
}

-(void)setCurrentSelectedCount:(NSInteger)currentSelectedCount{
    [BSPhotoConfig shareConfig].currentSelectedCount = currentSelectedCount;
}

-(void)setSupCamera:(BOOL)supCamera{
    [BSPhotoConfig shareConfig].supCamera = supCamera;
}

-(void)setSaveToAlbum:(BOOL)saveToAlbum{
    [BSPhotoConfig shareConfig].saveToAlbum = saveToAlbum;
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

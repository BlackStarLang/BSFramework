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
        [BSPhotoConfig shareConfig].mediaType = 0;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishSelectImage:) name:@"didFinishSelectImage" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishSelectVideo:) name:@"didFinishSelectVideo" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroupListData) name:@"auth_img_library" object:nil];

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

-(void)didFinishSelectVideo:(NSNotification *)noti{

    if ([[noti object]isKindOfClass:[NSString class]]) {
       
        NSString *path = [noti object];
        if ([self.BSDelegate respondsToSelector:@selector(BSPhotoCameraDidFinishedSelectVideoWithAVAsset:)]) {
            AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
            [self.BSDelegate BSPhotoCameraDidFinishedSelectVideoWithAVAsset:asset];
        }
        
    }else{
        
        AVAsset *asset = [noti object];
        if ([self.BSDelegate respondsToSelector:@selector(BSPhotoManagerDidFinishedSelectVideoWithAVAsset:)]) {
            [self.BSDelegate BSPhotoManagerDidFinishedSelectVideoWithAVAsset:asset];
        }
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
    
    [self configUIBarAppearance];
}

///使用xcode14运行后发现导航栏颜色在边缘时变成透明，
///所以改用苹果新API来配置导航和toolbar样式
- (void)configUIBarAppearance {
    if (@available(iOS 13.0, *)) {
        ///NaviBar
        UINavigationBarAppearance *naviBarAppearance = [[UINavigationBarAppearance alloc] init];
        if (self.navigationBar.isTranslucent) {
            UIColor *barTintColor = self.navigationBar.barTintColor;
            naviBarAppearance.backgroundColor = [barTintColor colorWithAlphaComponent:0.85];
        } else {
            naviBarAppearance.backgroundColor = self.navigationBar.barTintColor;
        }
        naviBarAppearance.titleTextAttributes = self.navigationBar.titleTextAttributes;
        self.navigationBar.standardAppearance = naviBarAppearance;
        self.navigationBar.scrollEdgeAppearance = naviBarAppearance;
        
        
        ///ToolBar
        UIToolbarAppearance *toolBarAppearance = [[UIToolbarAppearance alloc] init];
        if (self.toolbar.isTranslucent) {
            UIColor *barTintColor = self.toolbar.barTintColor;
            toolBarAppearance.backgroundColor = [barTintColor colorWithAlphaComponent:0.85];
        } else {
            toolBarAppearance.backgroundColor = self.navigationBar.barTintColor;
        }
        self.toolbar.standardAppearance = toolBarAppearance;
        if (@available(iOS 15.0, *)) {
            self.toolbar.scrollEdgeAppearance = toolBarAppearance;
        }
    }
}

-(void)setPreBarAlpha:(CGFloat)preBarAlpha{
    
    _preBarAlpha = preBarAlpha;
    [BSPhotoConfig shareConfig].preNaviAlpha = preBarAlpha;
}


/// 判断 颜色明暗
- (BOOL)isLighterColor:(UIColor *)color {
    if (!color) {
       return YES;
    }
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}


-(void)setMediaType:(NSInteger)mediaType{
    
    if (mediaType > 2) {
        mediaType = 2;
    }
    [BSPhotoConfig shareConfig].mediaType = mediaType;
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

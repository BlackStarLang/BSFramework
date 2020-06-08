//
//  BSPhotoPreviewController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/30.
//

#import "BSPhotoPreviewController.h"
#import "PhotoPreviewCell.h"
#import "BSPhotoModel.h"
#import "BSPhotoViewModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+BSBar.h"
#import "BSPhotoDataManager.h"
#import "BSPhotoNaviView.h"
#import "UIView+BSView.h"


@interface BSPhotoPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,assign) BOOL statusBarHiddenStatus;

@property (nonatomic ,strong) BSPhotoDataManager *dataManager;

@property (nonatomic ,assign) CGSize targetSize;

@property (nonatomic ,strong) BSPhotoNaviView *naviView;

@end

@implementation BSPhotoPreviewController


-(void)dealloc{
    NSLog(@"==== %@ dealloc =====",NSStringFromClass([self class]));
}


-(BOOL)prefersStatusBarHidden{
 
    return self.statusBarHiddenStatus;
}

#pragma mark - 生命周期

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.statusBarHiddenStatus = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self masonryLayout];
}


-(void)initSubViews{
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    self.targetSize = CGSizeMake(width * scale, height * scale);
    
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    /// 隐藏 系统 NavigationBar， 使用View 替换
    [self.navigationController setNavigationBarHidden:YES];
    self.naviView.backgroundColor = [UIColor whiteColor];
    self.naviView.frame = CGRectMake(0, 0, self.view.width, 64);
    [self.view addSubview:self.naviView];
    
    
    /// 自定义 navi 点击事件
    __weak typeof(self)weakSelf = self;
    self.naviView.naviAction = ^(BOOL isBack) {
        if (isBack) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}


-(void)masonryLayout{
    
    [self.collectionView setNeedsLayout];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}


#pragma mark - set method

-(void)setPreviewPhotos:(NSArray *)previewPhotos previewType:(PREVIEWTYPE)previewType defaultIndex:(NSInteger)defaultIndex{
    
    _previewPhotos = [NSMutableArray arrayWithArray:previewPhotos];
    _previewType = previewType;
    _currentIndex = defaultIndex;
}




#pragma mark - UICollectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.previewPhotos.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = self.view.frame.size.width + 20;
    CGFloat height = self.view.frame.size.height;

    return CGSizeMake(width, height);
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewCell" forIndexPath:indexPath];
    
    if (self.previewType == PREVIEWTYPE_URL) {
        
        NSString *url = self.previewPhotos[indexPath.row];
        NSURL *URL = [NSURL URLWithString:url];
        [cell.imageView sd_setImageWithURL:URL placeholderImage:nil];
        
    }else if (self.previewType == PREVIEWTYPE_PATH){
        
        NSString *path = self.previewPhotos[indexPath.row];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        cell.imageView.image = image;
        
    }else if (self.previewType == PREVIEWTYPE_IMAGE){
        
        UIImage *image = self.previewPhotos[indexPath.row];
        cell.imageView.image = image;
        
    }else if (self.previewType == PREVIEWTYPE_PHOTO){
        
        BSPhotoModel *model = self.previewPhotos[indexPath.row];
        
        __weak typeof(PhotoPreviewCell*)weakCell = cell;
        [self.dataManager getImageWithPHAsset:model.asset targetSize:self.targetSize imageBlock:^(UIImage *targetImage) {
            weakCell.imageView.image = targetImage;
        }];
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.naviView.top = self.statusBarHiddenStatus?0:-64;
            self.naviView.alpha = self.statusBarHiddenStatus?1:0;
        }];
        
        self.statusBarHiddenStatus =! self.statusBarHiddenStatus;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - systemDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.previewType == PREVIEWTYPE_PHOTO) {
        
        @autoreleasepool {
            
            CGFloat offsetX = scrollView.contentOffset.x + 20;
            NSInteger pageIndex = offsetX/self.collectionView.frame.size.width;
            
            NSMutableArray *assets = [NSMutableArray array];
            for (NSInteger i = pageIndex - 1; i<pageIndex + 1; i++) {
                if (i>0 && i<self.previewPhotos.count) {
                    BSPhotoModel *model = self.previewPhotos[i];
                    [assets addObject:model.asset];
                }
            }
            
            [self.dataManager startPreLoadCacheImagesWithPHAssetArray:assets targetSize:self.targetSize contenModel:PHImageContentModeAspectFit];
        }
    }
}



#pragma mark - init 属性初始化

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width+20, self.view.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:@"PhotoPreviewCell"];
    }
    return _collectionView;
}


-(BSPhotoDataManager *)dataManager{

    if (!_dataManager) {
        _dataManager = [[BSPhotoDataManager alloc]init];
    }
    return _dataManager;
}

-(BSPhotoNaviView *)naviView{
    if (!_naviView) {
        _naviView = [[BSPhotoNaviView alloc]init];
    }
    return _naviView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

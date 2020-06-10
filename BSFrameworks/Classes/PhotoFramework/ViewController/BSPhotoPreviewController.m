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


/// toolBar 视图
// 用来显示已选择照片数量
@property (nonatomic ,strong) UILabel *countLabel;
// 原图 按钮
@property (nonatomic ,strong) UIButton *selectOriginBtn;
// 完成 按钮
@property (nonatomic ,strong) UIButton *doneBtn;


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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIST_CELL_SELECT_STATUS" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initToolBarItems];
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
    
    self.selectOriginBtn.selected = self.isOrigin;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];
    
    [self initNaviView];
}


-(void)initNaviView{
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    BOOL iphoneX = NO;
    if (height == 812 || height == 896) {
        iphoneX = YES;
    }
    
    CGFloat naviHeight = self.navigationController.navigationBar.frame.size.height + (iphoneX?44:20);
    
    /// 隐藏 系统 NavigationBar， 使用View 替换
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.naviView.frame = CGRectMake(0, 0, self.view.width, naviHeight);
    [self.view addSubview:self.naviView];
    
    
    /// 初始化 时 naviView 右上角按钮图片
    BSPhotoModel *model = self.previewPhotos[self.currentIndex];
    if ([self.selectDataArr containsObject:model.identifier]) {
        [self.naviView setRightBtnImage:@"img_select"];
    }else{
        [self.naviView setRightBtnImage:@"img_unselect"];
    }
    
    
    /// 自定义 navi 点击事件
    __weak typeof(self)weakSelf = self;
    self.naviView.naviAction = ^(BOOL isBack) {
        if (isBack) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            

            
            CGFloat offsetX = weakSelf.collectionView.contentOffset.x;
            NSInteger pageIndex = offsetX/self.collectionView.frame.size.width;
            BSPhotoModel *model = weakSelf.previewPhotos[pageIndex];

            if ([weakSelf.selectDataArr containsObject:model.identifier]) {
                
                [weakSelf.selectDataArr removeObject:model.identifier];
                [weakSelf.naviView setRightBtnImage:@"img_unselect"];
                model.isSelect = NO;
                
            }else{
                /// 大于最大选择数，不再添加
                if (weakSelf.selectDataArr.count + weakSelf.currentSelectedCount >= weakSelf.allowSelectMaxCount) {
                    return;
                }
                [weakSelf.selectDataArr addObject:model.identifier];
                [weakSelf.naviView setRightBtnImage:@"img_select"];
                model.isSelect = YES;
            }
            weakSelf.countLabel.text = [NSString stringWithFormat:@"%ld",weakSelf.selectDataArr.count];
        }
    };
}


-(void)masonryLayout{
    
    [self.collectionView setNeedsLayout];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}


-(void)initToolBarItems{
    
    UIBarButtonItem *toolLeftItem = [[UIBarButtonItem alloc]initWithCustomView:self.selectOriginBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        
    UIView *originView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [originView addSubview:self.countLabel];
    [originView addSubview:self.doneBtn];
    
    UIBarButtonItem *toolRightItem = [[UIBarButtonItem alloc]initWithCustomView:originView];
    
    [self setToolbarItems:@[toolLeftItem,spaceItem,toolRightItem] animated:NO];
}


#pragma mark - set method

-(void)setMainColor:(UIColor *)mainColor{
    _mainColor = mainColor;
    
    self.naviView.backgroundColor = mainColor;
}

-(void)setPreviewPhotos:(NSMutableArray *)previewPhotos previewType:(PREVIEWTYPE)previewType defaultIndex:(NSInteger)defaultIndex{
    
    _previewPhotos = previewPhotos;
    _previewType = previewType;
    _currentIndex = defaultIndex;
}

#pragma mark - action 交互事件

-(void)originalImage:(UIButton *)sender{
    //是否使用原图
    sender.selected = !sender.selected;
}


-(void )doneBtnClick{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didFinishSelectImage" object:nil];
     [self dismissViewControllerAnimated:YES completion:nil];
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
        [self.dataManager getImageWithPHAsset:model.asset targetSize:self.targetSize contentModel:PHImageContentModeAspectFit imageBlock:^(UIImage *targetImage) {
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
        
        [self.navigationController setToolbarHidden:!self.statusBarHiddenStatus animated:YES];
        self.statusBarHiddenStatus =! self.statusBarHiddenStatus;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - systemDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.previewType == PREVIEWTYPE_PHOTO) {
        
        @autoreleasepool {
            
            CGFloat offsetX = scrollView.contentOffset.x;
            NSInteger pageIndex = offsetX/self.collectionView.frame.size.width;
            
            NSMutableArray *assets = [NSMutableArray array];
            for (NSInteger i = pageIndex - 1; i<pageIndex + 1; i++) {
                if (i>0 && i<self.previewPhotos.count) {
                    BSPhotoModel *model = self.previewPhotos[i];
                    [assets addObject:model.asset];
                }
            }
            
            [self.dataManager startPreLoadCacheImagesWithPHAssetArray:assets targetSize:self.targetSize contenModel:PHImageContentModeAspectFit];
            
            
            BSPhotoModel *model = self.previewPhotos[pageIndex];
            model.isSelect = NO;
            NSString *imgName = @"img_unselect";
            if ([self.selectDataArr containsObject:model.identifier]) {
                imgName = @"img_select";
                model.isSelect = YES;
            }
            
            [self.naviView setRightBtnImage:imgName];
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


-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 - 20, 12, 20, 20)];
        _countLabel.textAlignment = 1;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.layer.cornerRadius = 10;
        _countLabel.backgroundColor = [UIColor orangeColor];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.text = @"0";
    }
    return _countLabel;
}

-(UIButton *)selectOriginBtn{
    if (!_selectOriginBtn) {
        _selectOriginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 100)];
        _selectOriginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectOriginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [_selectOriginBtn setImage:[UIImage imageNamed:@"photo_original_def"] forState:UIControlStateNormal];
        [_selectOriginBtn setImage:[UIImage imageNamed:@"photo_original_sel"] forState:UIControlStateSelected];
        [_selectOriginBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_selectOriginBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_selectOriginBtn addTarget:self action:@selector(originalImage:) forControlEvents:UIControlEventTouchUpInside];
        [_selectOriginBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _selectOriginBtn;
}


-(UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 40, 44)];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _doneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);

        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
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

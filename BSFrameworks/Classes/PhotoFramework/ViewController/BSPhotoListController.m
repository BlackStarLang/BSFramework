//
//  BSPhotoListController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/29.
//

#import "BSPhotoListController.h"
#import <Masonry/Masonry.h>
#import "PhotoListCollectionCell.h"
#import "BSPhotoViewModel.h"
#import "BSPhotoDataManager.h"
#import "BSPhotoModel.h"
#import "BSPhotoGroupModel.h"
#import "BSPhotoPreviewController.h"
#import "BSPhotoPreviewVideoVC.h"
#import "BSCameraController.h"
#import <UIView+BSView.h>
#import "BSPhotoConfig.h"

@interface BSPhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BSPhotoProtocal>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,copy) NSMutableArray *dataSource;

@property (nonatomic ,strong) NSMutableArray *currentSelectArr;

@property (nonatomic ,strong) BSPhotoDataManager *dataManager;

@property (nonatomic ,assign) CGSize itemSize;
@property (nonatomic ,assign) CGFloat scale;

//当前colelctionView的中心坐标（参照物：scrollview）
@property (nonatomic ,assign) CGFloat centerY;

//第一次设置 滚动到底部
@property (nonatomic ,assign) BOOL firstScroll;


/// toolBar 视图
// 用来显示已选择照片数量
@property (nonatomic ,strong) UILabel *countLabel;
// 原图 按钮
@property (nonatomic ,strong) UIButton *selectOriginBtn;
// 完成 按钮
@property (nonatomic ,strong) UIButton *doneBtn;


@end

@implementation BSPhotoListController

#pragma mark - 生命周期

-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [self.dataManager stopAllCache];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return [BSPhotoConfig shareConfig].barStyle;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([BSPhotoConfig shareConfig].mediaType != 1) {
        [self.navigationController setToolbarHidden:NO];
    }else{
        [self.navigationController setToolbarHidden:YES];
    }
    self.selectOriginBtn.selected = [BSPhotoConfig shareConfig].isOrigin;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"REFRESH_LIST_CELL_SELECT_STATUS" object:nil];
    
    [self initSubViews];
    [self initToolBarItems];
    [self masonryLayout];
    [self configData:NO];
}



#pragma mark - prive method 自定义方法


-(void)initSubViews{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];

    CGFloat width = (self.view.frame.size.width-10)/4-5;
    self.itemSize = CGSizeMake(width, width);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = self.groupModel.title;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}


-(void)initToolBarItems{
    
    if ([BSPhotoConfig shareConfig].mediaType != 1) {
        
        if ([self isLighterColor:[BSPhotoConfig shareConfig].mainColor]) {
            [self.selectOriginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [self.selectOriginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }

        UIBarButtonItem *toolLeftItem = [[UIBarButtonItem alloc]initWithCustomView:self.selectOriginBtn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
            
        UIView *originView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        [originView addSubview:self.countLabel];
        [originView addSubview:self.doneBtn];
        
        UIBarButtonItem *toolRightItem = [[UIBarButtonItem alloc]initWithCustomView:originView];
        
        [self setToolbarItems:@[toolLeftItem,spaceItem,toolRightItem] animated:NO];
    }
}

- (BOOL)isLighterColor:(UIColor *)color {
    if (!color) {
        return YES;
    }
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}



-(void)masonryLayout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}


#pragma mark - 数据 相关

-(void)reloadData{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];
    [self.collectionView reloadData];
}


-(void)configData:(BOOL)selectLast{
    
    self.scale = [UIScreen mainScreen].scale;
    
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    if ([BSPhotoConfig shareConfig].mediaType == 0) {
        options.predicate =  [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];;
    }else if ([BSPhotoConfig shareConfig].mediaType == 1){
        options.predicate =  [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];;
    }
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.groupModel.assetCollection options:options];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (PHAsset *asset in result) {
        
        BSPhotoModel *model = [[BSPhotoModel alloc]init];
        model.asset = asset;
        if ([BSPhotoConfig shareConfig].mediaType == 2) {
            model.isVideo = NO;
        }else{
            model.isVideo = (asset.mediaType==2?YES:NO);
        }
        model.duration = asset.duration;
        model.identifier = asset.localIdentifier;
        if ([self.selectDataArr containsObject:asset.localIdentifier]) {
            model.isSelect = YES;
        }
        [array addObject:model];
    }

    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.collectionView reloadData];
    
    /// 如果拍照 ：点击下一步了
    if (selectLast) {
        /// 大于最大选择数，不再添加
        if (self.selectDataArr.count + [BSPhotoConfig shareConfig].currentSelectedCount < [BSPhotoConfig shareConfig].allowSelectMaxCount) {
            
            BSPhotoModel *model = self.dataSource.lastObject;
            model.isSelect = YES;
            [self.selectDataArr addObject:model.asset.localIdentifier];
            self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];
        }
    }

    ///延迟0.1，否则可能会出现 collectionView 没有滚动到最下边
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.firstScroll = YES;

        NSInteger row = self.dataSource.count - 1;
        if ([BSPhotoConfig shareConfig].supCamera) {
            row = self.dataSource.count;
        }

        self.collectionView.hidden = NO;
        
        ///通过 contentOffset 方式比较准确，测试数据7000张图片，无问题
        CGFloat offsetY = self.collectionView.contentSize.height - self.collectionView.height + self.navigationController.navigationBar.height + self.navigationController.toolbar.height;
        if (offsetY - 10 > 0) {
            ///-10 是因为设置了上下边距各5
            [self.collectionView setContentOffset:CGPointMake(0, offsetY - 10)];
        }

        self.centerY = self.collectionView.contentOffset.y + self.collectionView.height*3/4;
        self.firstScroll = NO;
    });
}


-(void)refreshSelectCount{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];
}


#pragma mark - action 交互事件

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)originalImage:(UIButton *)sender{
    //是否使用原图
    sender.selected = !sender.selected;
    [BSPhotoConfig shareConfig].isOrigin = sender.selected;
}


-(void )doneBtnClick{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didFinishSelectImage" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 相机协议 BSPhotoProtocal

-(void)photoCameraNextBtnClickedWithImage:(UIImage *)image{
    
    if ([BSPhotoConfig shareConfig].saveToAlbum == NO) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didFinishSelectImage" object:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        /// 存储到相册
        [self configData:YES];
    }
}


#pragma mark - UICollectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([BSPhotoConfig shareConfig].supCamera) {
        return self.dataSource.count + 1;
    }
    return self.dataSource.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoListCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.dataSource.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"photo_camera_icon"];
        cell.selectBtn.hidden = YES;
        cell.bottomView.hidden = YES;
        
    }else{
        
        BSPhotoModel *photoModel = self.dataSource[indexPath.row];
        cell.identifier = photoModel.identifier;
        
        [BSPhotoViewModel displayPhotoListCollectionCell:cell targetSize:CGSizeMake(self.itemSize.width*self.scale, self.itemSize.height*self.scale) photoModel:photoModel dataManager:self.dataManager];
        
        __weak typeof(self)weakSelf = self;
        cell.selectAction = ^(UIButton * _Nonnull sender) {
                        
            /// 大于最大选择数，不再添加
            if (weakSelf.selectDataArr.count + [BSPhotoConfig shareConfig].currentSelectedCount >= [BSPhotoConfig shareConfig].allowSelectMaxCount) {
                if (!sender.selected) {
                    return;
                }
            }
            sender.selected = !sender.selected;
            photoModel.isSelect = sender.selected;
            if (sender.selected) {
                [weakSelf.selectDataArr addObject:photoModel.asset.localIdentifier];
            }else{
                [weakSelf.selectDataArr removeObject:photoModel.asset.localIdentifier];
            }
            [weakSelf refreshSelectCount];
        };
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataSource.count) {
        /// 相机
        BSCameraController *cameraVC = [[BSCameraController alloc]init];
        cameraVC.saveToAlbum = [BSPhotoConfig shareConfig].saveToAlbum;
        cameraVC.delegate = self;
        
        NSInteger mediaType = [BSPhotoConfig shareConfig].mediaType;
        if (mediaType == 2) {
            mediaType = 0;
        }
        cameraVC.mediaType = mediaType;
        cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
        cameraVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cameraVC animated:YES];
  
    }else{
        
        if ([BSPhotoConfig shareConfig].mediaType == 1) {
            
            BSPhotoPreviewVideoVC *previewVC = [[BSPhotoPreviewVideoVC alloc]init];
            previewVC.preNaviAlpha = [BSPhotoConfig shareConfig].preNaviAlpha;
            previewVC.mainColor = [BSPhotoConfig shareConfig].mainColor;
            previewVC.barStyle = [BSPhotoConfig shareConfig].barStyle;
            previewVC.selectPreview = YES;
            [previewVC setPreviewVideos:self.dataSource defaultIndex:indexPath.row videoType:VIDEOTYPE_PHOTO];
            previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController pushViewController:previewVC animated:YES];
            
        }else{
            
            /// 图片预览
            BSPhotoPreviewController *previewVC = [[BSPhotoPreviewController alloc]init];
            [previewVC setPreviewPhotos:self.dataSource previewType:PREVIEWTYPE_PHOTO defaultIndex:indexPath.row];

            previewVC.allowSelectMaxCount = [BSPhotoConfig shareConfig].allowSelectMaxCount;
            previewVC.currentSelectedCount = [BSPhotoConfig shareConfig].currentSelectedCount;
            previewVC.preNaviAlpha = [BSPhotoConfig shareConfig].preNaviAlpha;
            previewVC.mainColor = [BSPhotoConfig shareConfig].mainColor;
            previewVC.barStyle = [BSPhotoConfig shareConfig].barStyle;
            previewVC.isOrigin = [BSPhotoConfig shareConfig].isOrigin;
            previewVC.selectDataArr = self.selectDataArr;
            previewVC.selectPreview = YES;
            previewVC.selectOriginImg = ^(BOOL isOrigin) {
                [BSPhotoConfig shareConfig].isOrigin = isOrigin;
            };
            previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController pushViewController:previewVC animated:YES];
        }
    }
}


#pragma mark - scrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.collectionView.height<=0 || self.firstScroll) {
        return;
    }

    CGRect visibleRect = CGRectMake(0, self.collectionView.contentOffset.y, self.view.width, self.collectionView.height);

    CGRect preLoadRect = CGRectInset(visibleRect, 0, -visibleRect.size.height * 0.5);


    // 预加载区域 中心点
    CGFloat preCenterY = preLoadRect.origin.y + preLoadRect.size.height/2;

    /// 纵向偏移量
    CGFloat offsetY = (preCenterY - self.centerY);


    if (ABS(offsetY)>=self.collectionView.height/3) {

        if (offsetY<0) {
            /// 向上
            CGRect startRect = CGRectMake(0, preLoadRect.origin.y, preLoadRect.size.width, preLoadRect.size.height/4);

            CGRect stopRect = CGRectMake(0, preLoadRect.origin.y + preLoadRect.size.height*3/4, preLoadRect.size.width, preLoadRect.size.height/4);

            [self startPreLoadRect:startRect stopPreLoadRect:stopRect];


        }else if (offsetY>0){
            /// 向下
            CGRect startRect = CGRectMake(0, preLoadRect.origin.y + preLoadRect.size.height*3/4, preLoadRect.size.width, preLoadRect.size.height/4);
            CGRect stopRect = CGRectMake(0, preLoadRect.origin.y, preLoadRect.size.width, preLoadRect.size.height/4);

            [self startPreLoadRect:startRect stopPreLoadRect:stopRect];
        }


        self.centerY = scrollView.contentOffset.y + self.collectionView.height/2;
    }
}

#pragma mark - 预加载图片功能
-(void)startPreLoadRect:(CGRect)startRect stopPreLoadRect:(CGRect)stopRect{
    
    NSArray *startArr = [self getPreArrWithRect:startRect];
    NSArray *stopArr = [self getPreArrWithRect:stopRect];

    /// 向上
    [self.dataManager startPreLoadCacheImagesWithPHAssetArray:startArr targetSize:CGSizeMake(self.itemSize.width*self.scale, self.itemSize.height*self.scale) contenModel:PHImageContentModeAspectFill];

    [self.dataManager stopPreLoadCacheImagesWithPHAssetArray:stopArr targetSize:CGSizeMake(self.itemSize.width*self.scale, self.itemSize.height*self.scale) contenModel:PHImageContentModeAspectFill];
}


-(NSArray *)getPreArrWithRect:(CGRect)rect{
    
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;

    NSArray *attriArr = [layout layoutAttributesForElementsInRect:rect];
    
    /// 加载 数组
    NSMutableArray *dataArr = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attri in attriArr) {
        
        if (self.dataSource.count>attri.indexPath.row) {
            BSPhotoModel *model = self.dataSource[attri.indexPath.row];
            [dataArr addObject:model.asset];
        }
    }
    
    return dataArr;
}


#pragma mark - init 属性初始化

-(BSPhotoDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[BSPhotoDataManager alloc]init];
    }
    return _dataManager;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.itemSize = self.itemSize;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.hidden = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoListCollectionCell class] forCellWithReuseIdentifier:@"PhotoListCollectionCell"];
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
        [_selectOriginBtn setImage:[UIImage imageNamed:@"photo_original_def"] forState:UIControlStateNormal];
        [_selectOriginBtn setImage:[UIImage imageNamed:@"photo_original_sel"] forState:UIControlStateSelected];
        [_selectOriginBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_selectOriginBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_selectOriginBtn addTarget:self action:@selector(originalImage:) forControlEvents:UIControlEventTouchUpInside];
        [_selectOriginBtn setAdjustsImageWhenHighlighted:NO];
        _selectOriginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectOriginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
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


-(NSMutableArray *)dataSource{
    return _dataSource=_dataSource?:[NSMutableArray array];
}

-(NSMutableArray *)currentSelectArr{
    return _currentSelectArr=_currentSelectArr?:[NSMutableArray array];
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

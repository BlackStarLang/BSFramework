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
#import "BSCameraController.h"
#import <UIView+BSView.h>

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


-(void)dealloc{
    NSLog(@"==== %@ dealloc =====",NSStringFromClass([self class]));
    [self.dataManager stopAllCache];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"REFRESH_LIST_CELL_SELECT_STATUS" object:nil];
    
    [self initSubViews];
    [self initToolBarItems];
    [self masonryLayout];
    [self configData];
}

-(void)reloadData{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];
    [self.collectionView reloadData];
}


-(void)initSubViews{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];

    CGFloat width = (self.view.frame.size.width-10)/4-5;
    self.itemSize = CGSizeMake(width, width);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = self.groupModel.title;
    [self.view addSubview:self.collectionView];
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


-(void)masonryLayout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}


-(void)configData{
    
    
    self.scale = [UIScreen mainScreen].scale;
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.groupModel.assetCollection options:nil];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [self.dataSource removeAllObjects];
    for (PHAsset *asset in result) {
        [array addObject:asset];
        
        BSPhotoModel *model = [[BSPhotoModel alloc]init];
        model.asset = asset;
        model.identifier = asset.localIdentifier;
        if ([self.selectDataArr containsObject:asset.localIdentifier]) {
            model.isSelect = YES;
        }
        [self.dataSource addObject:model];
    }
    
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.firstScroll = YES;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.centerY = self.collectionView.contentOffset.y + self.collectionView.height*3/4;
        self.firstScroll = NO;
    });

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
    
}

-(void )doneBtnClick{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didFinishSelectImage" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - prive method 自定义方法

-(void)refreshSelectCount{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.selectDataArr.count];
}

#pragma mark - prive delegate
-(void)photoCameraTakeBtnClicked{
    
    [self configData];
}


#pragma mark - UICollectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count + 1;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoListCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.dataSource.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"photo_camera_icon"];
        cell.selectBtn.hidden = YES;
        
    }else{
        
        BSPhotoModel *photoModel = self.dataSource[indexPath.row];
        cell.identifier = photoModel.identifier;
        
        [BSPhotoViewModel displayPhotoListCollectionCell:cell targetSize:CGSizeMake(self.itemSize.width*self.scale, self.itemSize.height*self.scale) photoModel:photoModel dataManager:self.dataManager];
        
        __weak typeof(self)weakSelf = self;
        cell.selectAction = ^(BOOL isSelect) {
            photoModel.isSelect = isSelect;
            if (isSelect) {
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
        BSCameraController *cameraVC = [[BSCameraController alloc]init];
        cameraVC.saveToAlbum = YES;
        cameraVC.delegate = self;
        cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:cameraVC animated:YES];
    }else{
        BSPhotoPreviewController *previewVC = [[BSPhotoPreviewController alloc]init];
        previewVC.selectDataArr = self.selectDataArr;
        previewVC.isOrigin = self.selectOriginBtn.selected;
        [previewVC setPreviewPhotos:self.dataSource previewType:PREVIEWTYPE_PHOTO defaultIndex:indexPath.row];
        previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}



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

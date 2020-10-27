//
//  BSPhotoPreviewVideoVC.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/23.
//

#import "BSPhotoPreviewVideoVC.h"
#import "PhotoPreviewVideoCell.h"
#import "BSPhotoNaviView.h"
#import "BSPhotoModel.h"
#import "BSPhotoDataManager.h"

@interface BSPhotoPreviewVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic ,strong) UICollectionView *collectionView;


@property (nonatomic ,assign) BOOL statusBarHiddenStatus;


@property (nonatomic ,strong) BSPhotoNaviView *naviView;


@property (nonatomic ,strong) UIButton *doneBtn;


@property (nonatomic ,strong) BSPhotoDataManager *dataManager;

@property (nonatomic ,strong) PhotoPreviewVideoCell *currentCell;
@property (nonatomic ,strong) NSIndexPath *indexPath;//即将加载的下标

@end

@implementation BSPhotoPreviewVideoVC

-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return self.barStyle;
}

-(BOOL)prefersStatusBarHidden{
 
    return self.statusBarHiddenStatus;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self masonryLayout];
    [self initBarHiddenStatus];
}

-(void)initSubViews{
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
        
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
    self.naviView.frame = CGRectMake(0, 0, self.view.frame.size.width, naviHeight);
    [self.view addSubview:self.naviView];
    
    
    /// 自定义 navi 点击事件
    __weak typeof(self)weakSelf = self;
    self.naviView.naviAction = ^(BOOL isBack) {
        if (isBack) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}


-(void)masonryLayout{
    
    [self.collectionView setNeedsLayout];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

-(void)initBarHiddenStatus{
    if (self.selectPreview) {
        [self initToolBarItems];
        [self.navigationController setToolbarHidden:NO];
        self.naviView.hiddenRightBtn = NO;
    }else{
        [self.navigationController setToolbarHidden:YES];
        self.naviView.hiddenRightBtn = YES;
    }
}


-(void)initToolBarItems{
    
    [self autoLightOrDark];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIBarButtonItem *toolLeftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        
    UIView *originView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [originView addSubview:self.doneBtn];
    
    UIBarButtonItem *toolRightItem = [[UIBarButtonItem alloc]initWithCustomView:originView];
    
    [self setToolbarItems:@[toolLeftItem,spaceItem,toolRightItem] animated:NO];
}

-(void)autoLightOrDark{
    
    if ([self isLighterColor:self.mainColor]) {
        [self.doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (BOOL)isLighterColor:(UIColor *)color {
    if (!color) {
        return YES;
    }
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}



#pragma mark public method

-(void)setMainColor:(UIColor *)mainColor{
    _mainColor = mainColor;
    self.naviView.backgroundColor = mainColor;
}

-(void)setPreNaviAlpha:(CGFloat)preNaviAlpha{
    _preNaviAlpha = preNaviAlpha;
    self.naviView.alpha = self.preNaviAlpha;
}


-(void)setPreviewVideos:(NSMutableArray *)previewVideos defaultIndex:(NSInteger)defaultIndex videoType:(VIDEOTYPE)videoType{
    
    _previewVideos = previewVideos;
    _currentIndex = defaultIndex;
    _videoType = videoType;
}


#pragma mark - action 交互事件

-(void)doneBtnClick{
    
    AVAsset *asset = self.currentCell.playerLayer.player.currentItem.asset;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didFinishSelectVideo" object:asset];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.previewVideos.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = self.view.frame.size.width + 20;
    CGFloat height = self.view.frame.size.height;

    return CGSizeMake(width, height);
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoPreviewVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewVideoCell" forIndexPath:indexPath];
    
    __weak typeof(PhotoPreviewVideoCell*)weakCell = cell;

    if (self.videoType == VIDEOTYPE_PHOTO) {
        BSPhotoModel *model = self.previewVideos[indexPath.row];
        
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize tsize = CGSizeMake(width * scale, height * scale);
        
        [self.dataManager getImageWithPHAsset:model.asset targetSize:tsize contentModel:PHImageContentModeAspectFit imageBlock:^(UIImage *targetImage) {
            weakCell.imageView.image = targetImage;
        }];
    }
    
    
    __weak typeof(self)weakSelf = self;
    cell.replayCallBack = ^{
        [weakSelf cell:weakCell willPlayVideoWithIndexPath:indexPath];
    };
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
        
    if (!self.indexPath) {
        [self cell:(PhotoPreviewVideoCell *)cell willPlayVideoWithIndexPath:indexPath];
    }
    self.indexPath = indexPath;
}



-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   
    /// 已经过去的cell 停止播放， player置空，replayBtn隐藏
    PhotoPreviewVideoCell *pcell = (PhotoPreviewVideoCell *)cell;
    [pcell.playerLayer.player pause];
    pcell.playerLayer.player = nil;
    pcell.replayBtn.hidden = YES;
    
    /// 即将播放的cell ，获取资源然后播放
    PhotoPreviewVideoCell *curCell = (PhotoPreviewVideoCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    [self cell:(PhotoPreviewVideoCell *)curCell willPlayVideoWithIndexPath:self.indexPath];
}


-(void)cell:(PhotoPreviewVideoCell *)cell willPlayVideoWithIndexPath:(NSIndexPath *)indexPath{
        
    if (self.videoType == VIDEOTYPE_PHOTO) {
        
        BSPhotoModel *model = self.previewVideos[indexPath.row];

        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;

        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",asset);
                AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
                AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
                cell.playerLayer.player = player;
                cell.replayBtn.hidden = YES;
                [player play];
                self.currentCell = cell;
                
                [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:item];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
            });
        }];
        
    }else if (self.videoType == VIDEOTYPE_URL){
        
        NSString *url = self.previewVideos[indexPath.row];
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:url]];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        cell.playerLayer.player = player;
        cell.replayBtn.hidden = YES;
        [player play];
        self.currentCell = cell;
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        
    }else if (self.videoType == VIDEOTYPE_AVASSET){
        
        AVAsset *asset = self.previewVideos[indexPath.row];
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        cell.playerLayer.player = player;
        cell.replayBtn.hidden = YES;
        [player play];
        self.currentCell = cell;
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        
    }else if (self.videoType == VIDEOTYPE_PATH){
        
        NSString *path = self.previewVideos[indexPath.row];
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        cell.playerLayer.player = player;
        cell.replayBtn.hidden = YES;
        [player play];
        self.currentCell = cell;
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    }
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.naviView.frame;
        frame.origin.y = self.statusBarHiddenStatus?0:-64;
        self.naviView.frame = frame;
        
        CGFloat alpha = self.preNaviAlpha;
        self.naviView.alpha = self.statusBarHiddenStatus?(alpha<=0?1:alpha):0;
    }];
    
    self.statusBarHiddenStatus =! self.statusBarHiddenStatus;
    [self setNeedsStatusBarAppearanceUpdate];

    if (self.selectPreview) {
        [self.navigationController setToolbarHidden:self.statusBarHiddenStatus animated:YES];
    }else{
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

#pragma mark notification

-(void)videoPlayToEnd:(NSNotification*)noti{
    
    self.currentCell.replayBtn.hidden = NO;
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
        _collectionView.alwaysBounceVertical = NO;
        [_collectionView registerClass:[PhotoPreviewVideoCell class] forCellWithReuseIdentifier:@"PhotoPreviewVideoCell"];
    }
    return _collectionView;
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


-(BSPhotoNaviView *)naviView{
    if (!_naviView) {
        _naviView = [[BSPhotoNaviView alloc]init];
    }
    return _naviView;
}

-(BSPhotoDataManager *)dataManager{

    if (!_dataManager) {
        _dataManager = [[BSPhotoDataManager alloc]init];
    }
    return _dataManager;
}

@end

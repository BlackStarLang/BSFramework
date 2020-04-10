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

@interface BSPhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,copy) NSMutableArray *dataSource;

@property (nonatomic ,strong) NSMutableArray *currentSelectArr;

@end

@implementation BSPhotoListController


-(void)dealloc{
    NSLog(@"==== %@ dealloc =====",NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubViews];
    [self masonryLayout];
    [self configData];
}


-(void)initSubViews{
    
    self.title = self.groupModel.title;
    self.navigationController.navigationBar.topItem.title = @"";
    [self.view addSubview:self.collectionView];
}


-(void)masonryLayout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}


-(void)configData{
    
    [BSPhotoDataManager getCurrentImageListFromBSPhotoGroupModel:self.groupModel libraryType:Library_Photo imageList:^(NSArray *imageList) {
       
        if (imageList.count) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:imageList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];

}




#pragma mark - UICollectionView delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count + 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.view.frame.size.width-10)/4-5;
    
    return CGSizeMake(width, width);
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoListCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
//        UIImage *image = [[UIImage imageNamed:@"photo_camera_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        cell.imageView.image = image;
//        cell.imageView.tintColor = [UIColor whiteColor];
//        cell.imageView.backgroundColor = [UIColor blackColor];
        cell.imageView.image = [UIImage imageNamed:@"photo_camera_icon"];
        cell.selectBtn.hidden = YES;
        
    }else{
        [BSPhotoViewModel displayPhotoListCollectionCell:cell photoModel:self.dataSource[indexPath.row - 1]];
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        BSCameraController *cameraVC = [[BSCameraController alloc]init];
        cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:cameraVC animated:YES];
    }else{
        BSPhotoPreviewController *previewVC = [[BSPhotoPreviewController alloc]init];
        previewVC.previewPhotos = self.dataSource;
        previewVC.currentIndex = indexPath.row;
        previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}


#pragma mark - init 属性初始化

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoListCollectionCell class] forCellWithReuseIdentifier:@"PhotoListCollectionCell"];
    }
    return _collectionView;
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

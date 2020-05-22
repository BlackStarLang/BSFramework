//
//  BSLooperView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/22.
//

#import "BSLooperView.h"
#import "UIView+BSView.h"

@interface BSLooperView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>


@end



@implementation BSLooperView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

-(void)initSubViews{
    
    self.collectionView.collectionViewLayout = self.flowLayout;
    
    [self addSubview:self.collectionView];
}

-(void)masonryLayout{
    
    self.collectionView.frame = CGRectMake(-10, 0, self.width + 20, self.height);
    
}



#pragma mark - set method

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    
    self.flowLayout.scrollDirection = scrollDirection;
}

-(void)setCollectionCell:(UICollectionViewCell *)collectionCell{
    _collectionCell = collectionCell;
    
    [self.collectionView registerClass:[collectionCell class] forCellWithReuseIdentifier:@"looperCell"];
}



#pragma mark - systemDelegate


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 5;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"looperCell" forIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(BSLooperView:cell:indexPath:)]) {
        [self.delegate BSLooperView:self cell:cell indexPath:indexPath];
    }
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(BSLooperView:didSelectIndexPath:)]) {
        [self.delegate BSLooperView:self didSelectIndexPath:indexPath];
    }
}




#pragma mark - init 属性初始化

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}


-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(self.width + 20, self.height);
        _flowLayout.minimumLineSpacing = 20;
        _flowLayout.minimumInteritemSpacing = 20;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    }
    return _flowLayout;
}


@end

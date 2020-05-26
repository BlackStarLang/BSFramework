//
//  BSLooperView.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/22.
//

#import "BSLooperView.h"
#import "UIView+BSView.h"
#import "objc/runtime.h"
#import <CoreFoundation/CoreFoundation.h>

@interface BSLooperView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic ,assign) NSInteger currentPageIndex;

/// 内置布局
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;

/// collectionView
@property (nonatomic ,strong) UICollectionView *collectionView;


@property (nonatomic ,strong) NSMutableArray *newDataArr;


@property (nonatomic ,strong) NSTimer *timer;

/// 是否是手动拖拽
@property (nonatomic ,assign) BOOL isDrag;


@property (nonatomic ,strong) TimerTarget *timerTarget;


@end



@implementation BSLooperView


-(void)dealloc{
    
    NSLog(@"BSLooperView 释放");
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

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
    
    self.timeLength = 3;
    [self addSubview:self.collectionView];
}


-(void)masonryLayout{
    

    
}



#pragma mark - set method

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    
    self.flowLayout.scrollDirection = scrollDirection;
}

-(void)setCellName:(NSString *)cellName{
    _cellName = cellName;
    
    [self.collectionView registerClass:NSClassFromString(cellName) forCellWithReuseIdentifier:cellName];
}


-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    if (dataArr.count) {
        
        /**
         * 如果 是无限循环 或者 自动滚动，
         * 使用新的newDataArr数组进行赋值
         */
        [self.newDataArr removeAllObjects];
        [self.newDataArr addObjectsFromArray:dataArr];
        [self.newDataArr addObjectsFromArray:dataArr];
        [self.newDataArr addObjectsFromArray:dataArr];

        [self.collectionView reloadData];
        
        self.currentPageIndex = dataArr.count;
        
        /// 默认滚动到 第二个数据源的第一个数组
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    if (self.AUTO) {
        [self creatTimer];
    }
}


/// 设置 collectionView 的滚动方向
-(void)setCollectionViewLayout:(UICollectionViewLayout *)layout{
    
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView reloadData];
}


/// 创建timer
-(void)creatTimer{
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (!self.timer) {
        if (self.timeLength<0.5) {
            self.timeLength = 3;
        }
        
        /**
         * 本来要加将timer 加入 runloop中（子线程加入，启动runloppe）
         * 加入后，发现无法停止timer，暂时未找到解决方案
         * 加runloop的好处就是，如果 滚动视图 的父视图 是ScrollView
         * 那么 ScrollView 的滚动 不影响timer的执行
         * 不加入runloop会造成 scrollview在滑动的时候timer 是暂停的（卡主）
         */
        self.timerTarget = [[TimerTarget alloc]init];
        self.timerTarget.target = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self.timerTarget selector:@selector(looperTime) userInfo:nil repeats:YES];
    }
}



#pragma mark - prive method 自定义方法

/// timer 回调
-(void)looperTime{

    self.isDrag = NO;
    [self resetCurrentPageIndex];
}


/// 重新设置 当前的 pageIndex 和 collectionView 要展示的cell
-(void)resetCurrentPageIndex{
    
    dispatch_async(dispatch_get_main_queue(), ^{


        //如果 自动轮播 或者 无限循环
        if (self.isCircle || self.AUTO) {
            
            if (self.AUTO && !self.isDrag) {
                //如果是 timer,设置滚动，带动画
                self.currentPageIndex ++;
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }else{
                //如果是 手动拖拽,计算 self.currentPageIndex
                self.currentPageIndex = self.collectionView.contentOffset.x/self.width;
            }
            
            
            /**
             * 当前 pageIndex < self.dataArr.count ，将当前 pageIndex
             * 重置为 self.dataArr.count + self.currentPageIndex
             *
             * 当前 pageIndex >= self.dataArr.count*2 ，将当前 pageIndex
             * 重置为 self.currentPageIndex - self.dataArr.count
             */
            
            if (self.currentPageIndex < self.dataArr.count) {
                
                /// 由于 自动滚动是有动画的，所以重置 collectionView 展示的cell需要延迟 0.5s
                
                NSTimeInterval refreshTime = self.isDrag?0:0.5;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(refreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count + self.currentPageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    if (self.AUTO) {
                        self.currentPageIndex = self.dataArr.count + self.currentPageIndex;
                    }
                    
                });
                
            }else if (self.currentPageIndex >= self.dataArr.count*2){
                
                /// 由于 自动滚动是有动画的，所以重置 collectionView 展示的cell需要延迟 0.5s
                NSTimeInterval refreshTime = self.isDrag?0:0.5;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(refreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPageIndex - self.dataArr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    if (self.AUTO) {
                        self.currentPageIndex = self.currentPageIndex - self.dataArr.count;
                    }
                    
                });
            }
        }
    });
}





#pragma mark - systemDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.isCircle) {
        return self.newDataArr.count;
    }else{
        return self.dataArr.count;
    }
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellName forIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(BSLooperView:cell:cellForModel:)]) {
        [self.delegate BSLooperView:self cell:cell cellForModel:self.newDataArr[indexPath.row]];
    }
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(BSLooperView:didSelectModel:)]) {
        [self.delegate BSLooperView:self didSelectModel:self.newDataArr[indexPath.row]];
    }
}


/// 减速时，重置 UICollectionView 位置（手动滚动）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //滚动到指定位置
    [self resetCurrentPageIndex];
    
    //如果自动轮播，开启timer
    if (self.AUTO) {
        [self creatTimer];
    }
}


/// 拖拽动作 ，timer 暂停
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.isDrag = YES;

    //如果自动轮播，拖拽时，停止timer
    if (self.AUTO) {
        [self.timer invalidate];
        self.timer = nil;
    }
}




#pragma mark - init 属性初始化

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(self.width, self.height);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

-(NSMutableArray *)newDataArr{
    if (!_newDataArr) {
        _newDataArr = [NSMutableArray array];
    }
    return _newDataArr;
}

@end






#pragma mark -
@implementation TimerTarget

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {

    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end

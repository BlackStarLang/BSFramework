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
#import "BSLooper3DFlowLayout.h"

@interface BSLooperView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>


#pragma mark - 属性


/// 当前轮播图的位置下标
@property (nonatomic ,assign) NSInteger currentPageIndex;


/// 内置布局
@property (nonatomic ,strong) BSLooper3DFlowLayout *flowLayout;


/// collectionView
@property (nonatomic ,strong) UICollectionView *collectionView;


/// 如果无限轮播 ，使用 新 数组
@property (nonatomic ,strong) NSMutableArray *newDataArr;


/// 计时器
@property (nonatomic ,strong) NSTimer *timer;


/// 是否是手动拖拽
@property (nonatomic ,assign) BOOL isDrag;


/// 用于 解决 timer 强引用 self 的问题
@property (nonatomic ,strong) TimerTarget *timerTarget;



@end


#pragma mark -
@implementation BSLooperView


#pragma mark - 生命周期
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
        [self configDefaultData];
        [self initSubViews];
    }
    return self;
}


#pragma mark - init method 初始化后基本配置

/// 配置默认数据
-(void)configDefaultData{
    
    self.itemSize = self.bounds.size;
    self.sectionInset = UIEdgeInsetsZero;
    self.timeLength = 3;
    self.minimumLineSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scale = 1;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}


-(void)initSubViews{

    [self addSubview:self.collectionView];
}




#pragma mark - set method

-(void)setAUTO:(BOOL)AUTO{
    _AUTO = AUTO;
    
    if (AUTO) {
        self.isInfinite = YES;
    }
}

-(void)setCellName:(NSString *)cellName{
    _cellName = cellName;
    /// 注册cell
    [self.collectionView registerClass:NSClassFromString(cellName) forCellWithReuseIdentifier:cellName];
}


-(void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    
}


-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    if (dataArr.count) {
        
        /// 设置 collectionView的frame 和 FlowLayout
        [self resetCollectionView];
        
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

-(void)resetCollectionView{
    
    self.flowLayout = [[BSLooper3DFlowLayout alloc]init];
    self.flowLayout.itemSize = self.itemSize;
    self.flowLayout.minimumLineSpacing = self.minimumLineSpacing;
    self.flowLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
    self.flowLayout.scrollDirection = self.scrollDirection;
    self.flowLayout.sectionInset = self.sectionInset;
    self.flowLayout.scale = self.scale;
    
    self.collectionView.collectionViewLayout = self.flowLayout;
    
    /// 设置 collectionView的frame
    self.collectionView.frame = self.bounds;
}


/// 设置 collectionView 的 自定义布局
-(void)setCollectionViewLayout:(UICollectionViewLayout *)layout{
    
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView reloadData];
}



#pragma mark - prive method 自定义方法

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

/// timer 回调
-(void)looperTime{

    self.isDrag = NO;
    [self resetCurrentPageIndex];
}


/// 重新设置 当前的 pageIndex 和 collectionView 要展示的cell

-(void)resetCurrentPageIndex{
    
    dispatch_async(dispatch_get_main_queue(), ^{


        //如果 自动轮播 或者 无限循环
        if (self.isInfinite || self.AUTO) {
            
            if (self.AUTO && !self.isDrag) {
                //如果是 timer,设置滚动，带动画
                self.currentPageIndex ++;
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            }else{
                //如果是 手动拖拽,计算 self.currentPageIndex
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    self.currentPageIndex = self.collectionView.contentOffset.y/(self.itemSize.height+self.minimumLineSpacing) + 1;
                }else{
                    self.currentPageIndex = self.collectionView.contentOffset.x/(self.itemSize.width+self.minimumLineSpacing) + 1;
                }
//                NSLog(@"currentPageIndex===%ld",self.currentPageIndex);
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
                   
                    NSInteger newPageIndex = self.dataArr.count + self.currentPageIndex;
                    
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:newPageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    if (self.AUTO) {
                        self.currentPageIndex = newPageIndex;
                    }
                    
                });
                
            }else if (self.currentPageIndex >= self.dataArr.count*2){
                
                /// 由于 自动滚动是有动画的，所以重置 collectionView 展示的cell需要延迟 0.5s
                NSTimeInterval refreshTime = self.isDrag?0:0.5;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(refreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    NSInteger newPageIndex = self.currentPageIndex - self.dataArr.count ;
                    
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:newPageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    if (self.AUTO) {
                        self.currentPageIndex = newPageIndex;
                    }
                    
                });
            }
        }
    });
}





#pragma mark - collectionView Delegete

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.isInfinite) {
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




#pragma mark - scrollView delegate

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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}

#pragma mark - init 属性初始化

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
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

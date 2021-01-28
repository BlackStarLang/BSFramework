//
//  BSLooper3DFlowLayout.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/29.
//

#import "BSLooper3DFlowLayout.h"
#import <ObjC/message.h>
#import "UIView+BSView.h"

@interface BSLooper3DFlowLayout ()

@property (nonatomic ,assign) BOOL isHorizontal;
@property (nonatomic ,assign) CGFloat space;

@end


@implementation BSLooper3DFlowLayout


-(void)prepareLayout{
    
    [super prepareLayout];
    
    self.isHorizontal = self.scrollDirection == UICollectionViewScrollDirectionHorizontal;
        
    if (self.loopStyle == BSLOOP_STYLE_NORMAL) {
        [self initNormalSettings];
    }else if (self.loopStyle == BSLOOP_STYLE_CARD){
        [self initCardSetting];
    }else{
        //预留
    }
}



/// 3D轮播图
-(void)initNormalSettings{
    
    if (self.isHorizontal) {
        /// collectionView 的 宽度 去掉 item 宽度
        CGFloat contentInset = self.collectionView.width - self.itemSize.width;
        
        
        /// 减速模式
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        
        /// 算出内边距
        self.collectionView.contentInset = UIEdgeInsetsMake(0, contentInset*0.5, 0, contentInset*0.5);
        
        
        /// 设置每个页面之间的间距
        if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setInterpageSpacing:")]) {
            ((void(*)(id,SEL,CGSize))objc_msgSend)(self.collectionView,NSSelectorFromString(@"_setInterpageSpacing:"),CGSizeMake(-(contentInset-self.minimumLineSpacing), 0));
        }
        
        /// 设置 page 的坐标（原理：正常坐标是 0.0，如果想让左边留下 30 的宽度，就需要 page 左移 30）
        /// 左移如果想要 item 的边距均分，就需要 左移 contentInset*0.5
        if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setPagingOrigin:")]) {
            ((void(*)(id,SEL,CGPoint))objc_msgSend)(self.collectionView,NSSelectorFromString(@"_setPagingOrigin:"),CGPointMake(-contentInset*0.5, 0));
        }
        
    }else{
        
        /// collectionView 的 宽度 去掉 item 宽度
        CGFloat contentInset = self.collectionView.height - self.itemSize.height;
        
        
        /// 减速模式
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        
        /// 算出内边距
        self.collectionView.contentInset = UIEdgeInsetsMake(contentInset*0.5, 0, contentInset*0.5, 0);
        
        
        /// 设置每个页面之间的间距
        if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setInterpageSpacing:")]) {
            ((void(*)(id,SEL,CGSize))objc_msgSend)(self.collectionView,NSSelectorFromString(@"_setInterpageSpacing:"),CGSizeMake(0, -(contentInset-self.minimumLineSpacing)));
        }
        
        /// 设置 page 的坐标（原理：正常坐标是 0.0，如果想让左边留下 30 的宽度，就需要 page 左移 30）
        /// 左移如果想要 item 的边距均分，就需要 左移 contentInset*0.5
        if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setPagingOrigin:")]) {
            ((void(*)(id,SEL,CGPoint))objc_msgSend)(self.collectionView,NSSelectorFromString(@"_setPagingOrigin:"),CGPointMake(0, -contentInset*0.5));
        }
    }
    
}



/// 卡片样式
-(void)initCardSetting{
    
//    if (self.miniScale == 0) {
//        self.miniScale = 0.5;
//    }
//
//    if (self.maxScale == 0) {
//        self.maxScale = 1;
//    }
    
    if (self.visibleCount == 0) {
        self.visibleCount = 3;
    }
    
    self.space = (self.collectionView.width - self.itemSize.width)/(self.visibleCount-1);
    
}



/// 布局
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (itemCount<=0) {
        return nil;
    }
    
    if (self.loopStyle == BSLOOP_STYLE_NORMAL) {
        
        NSArray *originArr = [super layoutAttributesForElementsInRect:rect];
        NSArray * array = [[NSArray alloc]initWithArray:originArr copyItems:YES];
        
        if (self.isHorizontal) {
            
            CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
            for (UICollectionViewLayoutAttributes * attrs in array) {
                
                [self set3DAttributesSettingsForHorizontalWithOriginAttri:attrs centerX:centerX];
            }
            return array;
            
        }else{
            
            CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height/2;
            for (UICollectionViewLayoutAttributes * attrs in array) {
                
                [self set3DAttributesSettingsForVerticalWithOriginAttri:attrs centerY:centerY];
            }
            return array;
        }
        
    }else if(self.loopStyle == BSLOOP_STYLE_CARD){
        
        NSMutableArray *array = [NSMutableArray array];
        if (self.isHorizontal) {

            CGFloat offsetX = self.collectionView.contentOffset.x;  /// collectionview偏移量
            int curPage = MAX(floor(offsetX/self.collectionView.width), 0) ; /// 当前是第几屏

            /// 偏移量百分比
            CGFloat curOffset = (int)offsetX % (int)self.collectionView.width * 1.0;
            CGFloat offsetPercent = curOffset/self.collectionView.width;

            
            /// 只处理当前可以看到的 item 的 Attributes
            NSInteger maxVisibleIndex = MIN(itemCount, self.visibleCount+curPage);
            for (int i = curPage; i<= maxVisibleIndex; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                UICollectionViewLayoutAttributes *attri = [self getCardAttributesWithIndexPath:indexPath currentPage:curPage offsetPercent:offsetPercent itemCount:itemCount];
                
                [array addObject:attri];
            }
        }
        
        return  array;
    }
    
    return [super layoutAttributesForElementsInRect:rect];
}



/// 设置3D轮播图的 Attributes 的样式（横向样式）
-(void)set3DAttributesSettingsForHorizontalWithOriginAttri:(UICollectionViewLayoutAttributes *)attri centerX:(CGFloat )centerX{
    
    //*********************************************//
    /**
     * 设置偏移量
     * 目的是为了让设置的行间距或纵间距生效
     *
     * 说明：
     * 如果正常 item size 设置 200 * 200 ，scale=0.5
     * 那么 中心item两边的 item 的大小则变成 100 * 100
     * 但是实际item所占的区域 200 * 200 并没有变，而item布局居中
     * 这样的问题就造成了：如果行间距为10 那么经过scale缩放，行间距就变成了60
     * 这就使 两个item 实际的 行间距或纵间距 发生了改变
     */
    //*********************************************//
    
    /// 计算需要改变的偏移量
    CGFloat offsetX = (self.itemSize.width - self.itemSize.width* self.scale)/2;
    
    /// 如果 在左侧 偏移量需要改成 负方向
    if (centerX>attri.center.x) {
        offsetX = offsetX * - 1;
    }
    
    /// attri的中心X坐标与 当前中心坐标的 X 差值的绝对值
    CGFloat distance = ABS(attri.center.x - centerX);
    
    /// 计算缩放比例
    CGFloat preScale = distance/(self.itemSize.width+self.minimumLineSpacing);
    
    
    /// 根据偏移量，重新设置 center
    attri.center = CGPointMake(attri.center.x - offsetX *preScale, attri.center.y + self.centerOffset * preScale);
    
    //*********************************************//
    //************      设置缩放动画     ************//
    //*********************************************//
    
    /// 根据设定的缩放比例，计算出最终需要的缩放比例
    CGFloat scale = (self.scale + (1-self.scale) * (1-preScale));
    
    /// 设置最终动画的缩放比例
    attri.transform=CGAffineTransformMakeScale(scale, scale);
    
}




/// 设置3D轮播图的 Attributes 的样式（纵向样式）
-(void)set3DAttributesSettingsForVerticalWithOriginAttri:(UICollectionViewLayoutAttributes *)attri centerY:(CGFloat )centerY{
    
    //*********************************************//
    /**
     * 设置偏移量
     * 目的是为了让设置的行间距或纵间距生效
     *
     * 说明：
     * 如果正常 item size 设置 200 * 200 ，scale=0.5
     * 那么 中心item两边的 item 的大小则变成 100 * 100
     * 但是实际item所占的区域 200 * 200 并没有变，而item布局居中
     * 这样的问题就造成了：如果行间距为10 那么经过scale缩放，行间距就变成了60
     * 这就使 两个item 实际的 行间距或纵间距 看起来并不正确
     */
    //*********************************************//
    
    /// 计算需要改变的偏移量
    CGFloat offsetY = (self.itemSize.height - self.itemSize.height* self.scale)/2;
    
    /// 如果 在左侧 偏移量需要改成 负方向
    if (centerY>attri.center.y) {
        offsetY = offsetY * - 1;
    }
    
    /// attri的中心X坐标与 当前中心坐标的 X 差值的绝对值
    CGFloat distance = ABS(attri.center.y - centerY);
    /// 计算缩放比例
    CGFloat preScale = distance/(self.itemSize.height+self.minimumLineSpacing);
    
    
    /// 根据偏移量，重新设置 center
    attri.center = CGPointMake(attri.center.x + self.centerOffset * preScale, attri.center.y - offsetY * preScale);
    
    //*********************************************//
    //************      设置缩放动画     ************//
    //*********************************************//
    
    /// 根据设定的缩放比例，计算出最终需要的缩放比例
    CGFloat scale = self.scale + (1-self.scale) * (1 - preScale);
    
    /// 设置最终动画的缩放比例
    attri.transform=CGAffineTransformMakeScale(scale, scale);
    
}




/// 获取卡片样式的 attributes
-(UICollectionViewLayoutAttributes *)getCardAttributesWithIndexPath:(NSIndexPath *)indexPath currentPage:(int)currentPage offsetPercent:(CGFloat)offsetPercent itemCount:(NSInteger)itemCount{
    
    CGFloat offsetX = self.collectionView.contentOffset.x;
    NSInteger visibleIndex = MAX(indexPath.item - currentPage + 1, 0);

    
    UICollectionViewLayoutAttributes *attri = [[self layoutAttributesForItemAtIndexPath:indexPath]copy];
    attri.size = self.itemSize;
    attri.center = CGPointMake(offsetX + self.itemSize.width/2 + self.space*(visibleIndex - 1) , self.collectionView.height/2);
    attri.zIndex = -attri.indexPath.item;
    
    CGFloat reverseScale = (float)(1.0 - self.scale) / (self.visibleCount-1);
    CGFloat scale = (1.0 - (visibleIndex - 1) * reverseScale + reverseScale * offsetPercent);

    attri.transform = CGAffineTransformMakeScale(scale, scale);
    
    
    if (visibleIndex == 1) {
        
        
        if (offsetX>0) {
            /// 当前item偏移量
            CGFloat curOffset = (int)offsetX % (int)self.collectionView.width * 1.0;
            attri.center = CGPointMake(attri.center.x - curOffset, attri.center.y);
        }else{
            /// 如果 collectionView 偏移量小于0，那么需要同其他一样，进行缩放
            attri.center = CGPointMake(attri.center.x + attri.size.width*(1-scale) /2 - self.space * offsetPercent, attri.center.y);
        }
       
    }else if (visibleIndex == self.visibleCount + 1 ){
        
        attri.center = CGPointMake(attri.center.x + attri.size.width*(1-scale)/2 - self.space, attri.center.y);

    }else{
        attri.center = CGPointMake(attri.center.x + attri.size.width*(1-scale) /2 - self.space * offsetPercent, attri.center.y);
    }

    return attri;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}




-(CGSize)collectionViewContentSize{
    
    if (self.loopStyle == BSLOOP_STYLE_CARD) {
        /// 卡片样式需要自己计算
        /// 不重新设置他的 ContentSize 将会导致
        /// 他的 ContentSize 不准确，最后几个cell 无法滑出去
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
        return CGSizeMake(self.collectionView.width * itemCount, self.collectionView.height);
    }
    return self.collectionView.contentSize;
}

@end

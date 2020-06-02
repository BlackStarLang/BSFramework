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

@end


@implementation BSLooper3DFlowLayout


-(void)prepareLayout{
    
    [super prepareLayout];
    
    self.isHorizontal = self.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    if (self.isHorizontal) {
        /// collectionView 的 宽度 去掉 item 宽度
        CGFloat contentInset = self.collectionView.width - self.itemSize.width;
        
        
        /// 减速模式
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        
        /// 算出内边距
        self.collectionView.contentInset = UIEdgeInsetsMake(0, contentInset*0.5, 0, contentInset*0.5);
        
        
        /// 设置每个page的间距,正常 是 colectionView 的宽度，但是现在需要做成自己想要的宽度，则把多于的去掉
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
        
        
        /// 设置每个page的间距,正常 是 colectionView 的宽度，但是现在需要做成自己想要的宽度，则把多于的去掉
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



-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *originArr = [super layoutAttributesForElementsInRect:rect];
    
    NSArray * array = [[NSArray alloc]initWithArray:originArr copyItems:YES];

    
    if (self.isHorizontal) {
        
        CGFloat centetX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
        
        for (UICollectionViewLayoutAttributes * attrs in array) {
            
            
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
            if (centetX>attrs.center.x) {
                offsetX = offsetX * - 1;
            }
            
            /// attri的中心X坐标与 当前中心坐标的 X 差值的绝对值
            CGFloat distance = ABS(attrs.center.x - centetX);
            
            /// 计算缩放比例
            CGFloat preScale = distance/(self.itemSize.width+self.minimumLineSpacing);
//            preScale = MIN(1, preScale);
            
            /// 根据偏移量，重新设置 center
            attrs.center = CGPointMake(attrs.center.x - offsetX *preScale, attrs.center.y + self.centerOffset * preScale);
           
            //*********************************************//
            //************      设置缩放动画     ************//
            //*********************************************//
            
            /// 根据设定的缩放比例，计算出最终需要的缩放比例
            CGFloat scale = (self.scale + (1-self.scale) * (1-preScale));
            
            /// 设置最终动画的缩放比例
            attrs.transform=CGAffineTransformMakeScale(scale, scale);

        }
        return array;
        
        
    }else{
        
        
        CGFloat centetY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height/2;
                
        for (UICollectionViewLayoutAttributes * attrs in array) {
            
            
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
            if (centetY>attrs.center.y) {
                offsetY = offsetY * - 1;
            }
            
            /// attri的中心X坐标与 当前中心坐标的 X 差值的绝对值
            CGFloat distance = ABS(attrs.center.y - centetY);
            /// 计算缩放比例
            CGFloat preScale = distance/(self.itemSize.height+self.minimumLineSpacing);
            preScale = MIN(1, preScale);

            /// 根据偏移量，重新设置 center
            attrs.center = CGPointMake(attrs.center.x + self.centerOffset * preScale, attrs.center.y - offsetY * preScale);
            
            //*********************************************//
            //************      设置缩放动画     ************//
            //*********************************************//
            
            /// 根据设定的缩放比例，计算出最终需要的缩放比例
            CGFloat scale = self.scale + (1-self.scale) * (1 - preScale);
            
            /// 设置最终动画的缩放比例
            attrs.transform=CGAffineTransformMakeScale(scale, scale);
            
        }
        return array;
        
    }
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end

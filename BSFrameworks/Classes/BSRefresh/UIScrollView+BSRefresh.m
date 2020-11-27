//
//  UIScrollView+BSRefresh.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/11/11.
//

#import "UIScrollView+BSRefresh.h"
#import "BSRefreshHeaderView.h"
#import "UIView+BSView.h"
#import <objc/runtime.h>

@implementation UIScrollView (BSRefresh)

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerBlockCallBack) name:@"bsHeaderBlockCallBack" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(footerBlockCallBack) name:@"bsFooterBlockCallBack" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}

#pragma mark - headerView
-(void)setBsHeader:(BSRefreshHeaderView *)bsHeader{
    
    if (self.bsHeader != bsHeader) {
        if (self.bsHeader && self.bsHeader.superview) {
            [self.bsHeader removeFromSuperview];
            [self addSubview:bsHeader];
        }
        objc_setAssociatedObject(self, @"bsHeader", bsHeader, OBJC_ASSOCIATION_RETAIN);
    }
}


-(BSRefreshHeaderView *)bsHeader{
    
    BSRefreshHeaderView *headerView = objc_getAssociatedObject(self, @"bsHeader");
    return headerView;
}





#pragma mark - footerView
- (void)setBsFooter:(BSRefreshFooterView *)bsFooter{
    
    if (self.bsFooter != bsFooter) {
        if (self.bsFooter && self.bsFooter.superview) {
            [self.bsFooter removeFromSuperview];
            [self addSubview:bsFooter];
        }
        objc_setAssociatedObject(self, @"bsFooter", bsFooter, OBJC_ASSOCIATION_RETAIN);
    }
}


-(BSRefreshFooterView *)bsFooter{
    
    BSRefreshFooterView *footeerView = objc_getAssociatedObject(self, @"bsFooter");
    return footeerView;
}


#pragma mark - 属性

#pragma mark 上拉加载更多如果没有数据了的处理
-(void)setNoMoreData:(BOOL)noMoreData{
        
    self.bsFooter.BSStatus = BS_STATUS_NORMAL;
    self.bsFooter.noMoreData = noMoreData;
    objc_setAssociatedObject(self, @"BS_NOMORE_DATA", @(noMoreData), OBJC_ASSOCIATION_ASSIGN);
}


-(BOOL)noMoreData{
    NSNumber *isEmpty = objc_getAssociatedObject(self, @"BS_NOMORE_DATA");
    return isEmpty.boolValue;
}


#pragma mark 是否是预加载
-(void)setPreLoad:(BOOL)preLoad{
    
    objc_setAssociatedObject(self, @"BS_PRE_LOAD", @(preLoad), OBJC_ASSOCIATION_ASSIGN);
}


-(BOOL)preLoad{
    
    NSNumber *preLoad = objc_getAssociatedObject(self, @"BS_PRE_LOAD");
    return preLoad.boolValue;
}






#pragma mark - Block 初始化

#pragma mark 普通刷新样式
-(void)setHeaderRefreshBlock:(void (^)(UIScrollView * _Nonnull))headerRefreshBlock{
    
    objc_setAssociatedObject(self, @"BSHeaderRefreshBlock", headerRefreshBlock, OBJC_ASSOCIATION_COPY);
    
    self.bsHeader = [[BSRefreshHeaderView alloc]init];
    [self addSubview:self.bsHeader];
}


- (void (^)(UIScrollView * _Nonnull))headerRefreshBlock{
    
    return objc_getAssociatedObject(self, @"BSHeaderRefreshBlock");
}



-(void)setFooterRefreshBlock:(void (^)(UIScrollView * _Nonnull))footerRefreshBlock{
    
    objc_setAssociatedObject(self, @"BSFooterRefreshBlock", footerRefreshBlock, OBJC_ASSOCIATION_COPY);
    
    self.bsFooter = [[BSRefreshFooterView alloc]init];
    [self addSubview:self.bsFooter];
    
}


-(void (^)(UIScrollView * _Nonnull))footerRefreshBlock{
    
    return objc_getAssociatedObject(self, @"BSFooterRefreshBlock");
}



#pragma mark 无文字刷新

-(void)setHeaderNoTextRefreshBlock:(void (^)(UIScrollView * _Nonnull))headerNoTextRefreshBlock{
    
    objc_setAssociatedObject(self, @"BSHeaderNoTextRefreshBlock", headerNoTextRefreshBlock, OBJC_ASSOCIATION_COPY);
    
    self.bsHeader = [[BSRefreshHeaderView alloc]init];
    self.bsHeader.emptyText = YES;
    [self addSubview:self.bsHeader];
    
}


-(void (^)(UIScrollView * _Nonnull))headerNoTextRefreshBlock{
    
    return objc_getAssociatedObject(self, @"BSHeaderNoTextRefreshBlock");
}



-(void)setFooterNoTextRefreshBlock:(void (^)(UIScrollView * _Nonnull))footerNoTextRefreshBlock{
    
    objc_setAssociatedObject(self, @"BSFooterNoTextRefreshBlock", footerNoTextRefreshBlock, OBJC_ASSOCIATION_COPY);
    
    self.bsFooter = [[BSRefreshFooterView alloc]init];
    self.bsFooter.emptyText = YES;
    [self addSubview:self.bsFooter];
    
    
    self.preLoad = NO;
}


-(void (^)(UIScrollView * _Nonnull))footerNoTextRefreshBlock{
    
    return objc_getAssociatedObject(self, @"BSFooterNoTextRefreshBlock");
}



#pragma mark 预加载footerBlock

-(void)setFooterPreLoadBlock:(void (^)(UIScrollView * _Nonnull))footerPreLoadBlock{
    
    objc_setAssociatedObject(self, @"BSFooterPreLoadBlock", footerPreLoadBlock, OBJC_ASSOCIATION_COPY);
    
    self.bsFooter = [[BSRefreshFooterView alloc]init];

    self.bsFooter.emptyText = NO;
    [self addSubview:self.bsFooter];
    
    self.preLoad = YES;
}


-(void (^)(UIScrollView * _Nonnull))footerPreLoadBlock{
    
    return objc_getAssociatedObject(self, @"BSFooterPreLoadBlock");
}



-(void)headerBlockCallBack{
    
    if (self.headerRefreshBlock) {
        self.headerRefreshBlock(self);
    }
    
    if (self.headerNoTextRefreshBlock) {
        self.headerNoTextRefreshBlock(self);
    }
    //如果下拉刷新，将footer 设置为可上拉加载更多
    self.noMoreData = NO;
}


-(void)footerBlockCallBack{
    
    if (self.footerRefreshBlock) {
        self.footerRefreshBlock(self);
    }
    
    if (self.footerNoTextRefreshBlock) {
        self.footerNoTextRefreshBlock(self);
    }
    
    if (self.footerPreLoadBlock) {
        self.footerPreLoadBlock(self);
    }
}


-(void)endHeaderRefresh{
    
}

-(void)endFooterRefresh{
    
}



-(void)endAllRefresh{
    [self endHeaderRefresh];
    [self endFooterRefresh];
}



@end

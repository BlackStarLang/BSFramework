//
//  BSClassifyScrollView.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSClassifyScrollView.h"

@interface BSClassifyScrollView ()<UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray *itemsBtn;

@end


@implementation BSClassifyScrollView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView{
    
    self.backgroundColor = [UIColor whiteColor];
}


-(void)setItemsTitle:(NSArray *)itemsTitle{
    _itemsTitle = itemsTitle;
    
    [self.itemsBtn makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemsBtn removeAllObjects];
    
    if (itemsTitle.count<=0) return;
   
    for (int i = 0; i<itemsTitle.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn setTitle:itemsTitle[i] forState:UIControlStateNormal];
    }
    
}



#pragma mark - init 属性初始化

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}


-(NSMutableArray *)itemsBtn{
    if (!_itemsBtn) {
        _itemsBtn = [NSMutableArray array];
    }
    
    return _itemsBtn;
}



@end

//
//  BSLooperViewVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/2.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSLooperViewVC.h"
#import "BSLooperView.h"
#import "BSCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+BSView.h"



@interface BSLooperViewVC ()<BSLooperViewDelegate>

@property (nonatomic ,strong) BSLooperView *looperView;

@end

@implementation BSLooperViewVC

-(void)dealloc{
//    NSLog(@"BSLooperViewVC 释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self initSubView];
    [self configData];
    
}

-(void)initSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.looperView];
}


/// 配置 数据
-(void)configData{
    
    NSString *url = @"https://pics6.baidu.com/feed/0dd7912397dda144302b8277f02262a40df48675.jpeg?token=0f893277230d6dbe88ac6ed35e0be20d";
    NSString *url1 = @"https://pics0.baidu.com/feed/8b82b9014a90f60375143a228c59041db151ed85.jpeg?token=bf540b320d9f8fe20b306f4a0f863378";
    NSString *url2 = @"https://wenhui.whb.cn/u/cms/www/202005/251008229olq.png";
    NSString *url3 = @"https://pics5.baidu.com/feed/5fdf8db1cb13495446f2bdd96d87245ed3094aea.jpeg?token=4a4ada5a734da5504dfb371cd74ecf78";

    self.looperView.dataArr = @[url,url1,url2,url3];
}



#pragma mark - BSLooperViewDelegate

/// 通过 代理方法进行 cell 的操作
-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell cellForModel:(id)model{
    
    BSCollectionViewCell *looperCell = (BSCollectionViewCell *)cell;
    
    [looperCell.cellImageView sd_setImageWithURL:[NSURL URLWithString:model]];
}




#pragma mark - init 属性初始化

-(BSLooperView *)looperView{
    if (!_looperView) {
        _looperView = [[BSLooperView alloc]initWithFrame:CGRectMake(0, 300, self.view.width, 300)];
        _looperView.cellName = @"BSCollectionViewCell";
        _looperView.delegate = self;
        _looperView.itemSize = CGSizeMake(self.view.width - 40, 260);
        _looperView.minimumLineSpacing = 10;
        _looperView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _looperView.scale = 0.7;
        _looperView.isInfinite = YES;
        _looperView.AUTO = YES;

        _looperView.looperPosition = BSLooperPositionLeft;
    }
    return _looperView;
}



@end

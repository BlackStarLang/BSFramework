//
//  BSSecondController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/5/25.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSSecondController.h"
#import "BSLooperView.h"
#import "BSCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface BSSecondController ()<BSLooperViewDelegate>

@property (nonatomic ,strong) BSLooperView *looperView;

@end

@implementation BSSecondController

-(void)dealloc{
    
    NSLog(@"BSSecondController 释放");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addLooperView];
}

-(void)addLooperView{
    
    self.looperView = [[BSLooperView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 300)];
    self.looperView.cellName = @"BSCollectionViewCell";
    self.looperView.delegate = self;
    self.looperView.isCircle = YES;
    self.looperView.AUTO = YES;
    
    
    NSString *url = @"https://pics6.baidu.com/feed/0dd7912397dda144302b8277f02262a40df48675.jpeg?token=0f893277230d6dbe88ac6ed35e0be20d";
    NSString *url1 = @"https://pics0.baidu.com/feed/8b82b9014a90f60375143a228c59041db151ed85.jpeg?token=bf540b320d9f8fe20b306f4a0f863378";
    NSString *url2 = @"https://wenhui.whb.cn/u/cms/www/202005/251008229olq.png";
    NSString *url3 = @"https://pics5.baidu.com/feed/5fdf8db1cb13495446f2bdd96d87245ed3094aea.jpeg?token=4a4ada5a734da5504dfb371cd74ecf78";

    self.looperView.dataArr = @[url,url1,url2,url3];
    [self.view addSubview:self.looperView];

}


-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell cellForModel:(id)model{
    
    BSCollectionViewCell *bsCell = (BSCollectionViewCell *)cell;

    [bsCell.cellImageView sd_setImageWithURL:[NSURL URLWithString:model]];
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

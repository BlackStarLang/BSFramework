//
//  BSViewController.m
//  BSFrameworks
//
//  Created by blackstar_lang@163.com on 03/28/2020.
//  Copyright (c) 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSViewController.h"

#import "BSPhotoProtocal.h"
#import "TZImagePickerController.h"
#import "BSPhotoManagerController.h"
#import "BSLooperView.h"
#import <UIImageView+WebCache.h>
#import <UIView+BSView.h>


@interface BSViewController ()<BSPhotoProtocal,TZImagePickerControllerDelegate,BSLooperViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation BSViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];

    BSLooperView *looperView = [[BSLooperView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    looperView.collectionCell = [[UICollectionViewCell alloc]init];
    looperView.delegate = self;
    
    [self.view addSubview:looperView];
}


- (IBAction)gotoPhotoLibrary:(UIButton *)sender {
    
    BSPhotoManagerController *groupVC = [[BSPhotoManagerController alloc]init];

    groupVC.autoPush = YES;
    groupVC.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:groupVC animated:YES completion:nil];
}



-(void)BSLooperView:(BSLooperView *)looperView cell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, self.view.width - 60, 300)];
    [cell.contentView addSubview:imageView];
    
    NSString *url = @"https://pics6.baidu.com/feed/0dd7912397dda144302b8277f02262a40df48675.jpeg?token=0f893277230d6dbe88ac6ed35e0be20d";
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
}



-(void)photoCameraNextBtnClickedWithImage:(UIImage *)image{
    
    self.imageView.image = image;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

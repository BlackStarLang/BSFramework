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
#import "BSSecondController.h"

#import "BSCollectionViewCell.h"


@interface BSViewController ()<BSPhotoProtocal,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation BSViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];


}



#pragma mark - camera

- (IBAction)gotoPhotoLibrary:(UIButton *)sender {
    
//    BSPhotoManagerController *groupVC = [[BSPhotoManagerController alloc]init];
//
//    groupVC.autoPush = YES;
//    groupVC.modalPresentationStyle = UIModalPresentationFullScreen;
//
//    [self presentViewController:groupVC animated:YES completion:nil];
//
    
    BSSecondController *bsSecond = [[BSSecondController alloc]init];
    bsSecond.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:bsSecond animated:YES];
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

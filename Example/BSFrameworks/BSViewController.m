//
//  BSViewController.m
//  BSFrameworks
//
//  Created by blackstar_lang@163.com on 03/28/2020.
//  Copyright (c) 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSViewController.h"
#import "BSTestViewController.h"

#import "BSPhotoProtocal.h"
#import "TZImagePickerController.h"
#import "BSPhotoManagerController.h"

@interface BSViewController ()<BSPhotoProtocal,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mybutton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)gotoPhotoLibrary:(UIButton *)sender {
    
    BSPhotoManagerController *groupVC = [[BSPhotoManagerController alloc]init];

    groupVC.autoPush = YES;
    groupVC.modalPresentationStyle = UIModalPresentationFullScreen;

    
//    TZImagePickerController *groupVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//
//    // You can get the photos by block, the same as by delegate.
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [groupVC setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
//
//    }];
//    groupVC.modalPresentationStyle = 0;
    [self presentViewController:groupVC animated:YES completion:nil];
}

- (IBAction)button2push:(UIButton *)sender {
 
    BSTestViewController * vc = [[BSTestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
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

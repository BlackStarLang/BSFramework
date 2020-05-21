//
//  BSViewController.m
//  BSFrameworks
//
//  Created by blackstar_lang@163.com on 03/28/2020.
//  Copyright (c) 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSViewController.h"
#import "BSTestViewController.h"
#import "BSCameraController.h"
#import "BSPhotoProtocal.h"

#import <BSPhotoGroupController.h>

@interface BSViewController ()<BSPhotoProtocal>

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
    
    BSPhotoGroupController *groupVC = [[BSPhotoGroupController alloc]init];
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:groupVC];
//    navi.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:navi animated:YES completion:nil];
    groupVC.autoPush = YES;
    groupVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:groupVC animated:NO];
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

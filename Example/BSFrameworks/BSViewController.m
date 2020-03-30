//
//  BSViewController.m
//  BSFrameworks
//
//  Created by blackstar_lang@163.com on 03/28/2020.
//  Copyright (c) 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSViewController.h"
#import "BSTestViewController.h"

#import <BSPhotoGroupController.h>

@interface BSViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mybutton;



@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)gotoPhotoLibrary:(UIButton *)sender {
    
    BSPhotoGroupController *groupVC = [[BSPhotoGroupController alloc]init];
    
    [self.navigationController pushViewController:groupVC animated:YES];
    
}

- (IBAction)button2push:(UIButton *)sender {
 
    BSTestViewController * vc = [[BSTestViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

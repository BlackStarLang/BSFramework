//
//  BSATransitionController.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/11/26.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BSATransitionController : UIViewController

-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithAlertTitle:(NSString *)title message:(NSString *)message delegate:(__strong UIViewController *)delegate;


@end



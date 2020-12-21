//
//  UIViewController+WhiteController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/17.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "UIViewController+WhiteController.h"

#import <objc/runtime.h>

@implementation UIViewController (WhiteController)

+(void)load{
    Method org_viewdidload = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method new_bsviewdidload = class_getInstanceMethod(self, @selector(bsViewDidLoad));
    method_exchangeImplementations(org_viewdidload, new_bsviewdidload);
}


-(void)bsViewDidLoad{
    [self bsViewDidLoad];
    
    Class inputClass = NSClassFromString(@"UIInputWindowController");
    Class editClass = NSClassFromString(@"UIEditingOverlayViewController");

    if (![self isKindOfClass:[UINavigationController class]] && ![self isKindOfClass:inputClass]&& ![self isKindOfClass:editClass]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
}



@end

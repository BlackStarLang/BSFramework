//
//  BSTransitionBoostController.h
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/23.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSTransitionBoostController : UIViewController 

-(instancetype)initWithBoostView:(UIView *)boostView presentViewController:(UIViewController *)presentViewController;

@end

NS_ASSUME_NONNULL_END

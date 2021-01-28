//
//  BSWebViewController.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/8.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BSWebViewControllerDelegate <NSObject>

@optional
-(void)delegateTest;


@end


@interface BSWebViewController : UIViewController

@property (nonatomic ,weak) id<BSWebViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

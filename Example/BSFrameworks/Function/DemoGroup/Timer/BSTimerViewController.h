//
//  BSTimerViewController.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/1/15.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BSTimerViewController : UIViewController

@end



@interface TimeTarget : NSProxy


@property (nonatomic ,weak) BSTimerViewController *timerOwner;

@end

//
//  BSButton.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/7/6.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSButton.h"

@implementation BSButton



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view) {
        NSLog(@"==%@==",view);
    }
    
    return view;
}



@end

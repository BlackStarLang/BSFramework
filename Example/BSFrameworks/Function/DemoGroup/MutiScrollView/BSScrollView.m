//
//  BSScrollView.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/4/6.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSScrollView.h"

@interface BSScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation BSScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/// 同时识别手势，可理解为，手势主体与主体容器同时识别手势，
/// 即嵌套的tableview，同时识别手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

@end

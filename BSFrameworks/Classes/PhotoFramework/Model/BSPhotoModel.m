//
//  BSPhotoModel.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import "BSPhotoModel.h"

@implementation BSPhotoModel

-(void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    
    NSString *time = @"0";

    if (duration<10) {
        
        time = [NSString stringWithFormat:@"0:0%.f",duration];
        
    }else if (duration<60 && duration >=10){
        
        time = [NSString stringWithFormat:@"0:%.f",duration];
        
    }else if (duration>=60 && duration < 600){
        
        int minutes = duration/60;
        int second = (int)duration % 60;
        
        if (second<10) {
            time = [NSString stringWithFormat:@"%d:0%d",minutes,second];
        }else{
            time = [NSString stringWithFormat:@"%d:%d",minutes,second];
        }

    }else{
        
        // 小时显示
        int hour = duration/60/60;
        int minutes = (int)duration / 60 % 60;
        int second = (int)duration % 60;
        
        NSString *minutesStr = @"";
        if (minutes<10) {
            minutesStr = [NSString stringWithFormat:@"0%d",minutes];
        }else{
            minutesStr = [NSString stringWithFormat:@"%d",minutes];
        }
        
        if (second<10) {
            time = [NSString stringWithFormat:@"%d:%@:0%d",hour,minutesStr,second];
        }else{
            time = [NSString stringWithFormat:@"%d:%@:%d",hour,minutesStr,second];
        }
        
    }
    
    self.durationStr = time;
}

@end

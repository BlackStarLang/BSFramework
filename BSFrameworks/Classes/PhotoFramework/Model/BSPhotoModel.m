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

    if (duration<60) {
        
        //秒
        self.durationStr = [NSString stringWithFormat:@"0:%02d",(int)duration];
        
    }else if (duration>=60 && duration < 3600){
        
        //分钟
        int minutes = duration/60;
        int second = (int)duration % 60;
        self.durationStr = [NSString stringWithFormat:@"%02d:%02d",minutes,second];

    }else{
        
        // 小时显示
        int hour = duration/60/60;
        int minutes = (int)duration / 60 % 60;
        int second = (int)duration % 60;
        self.durationStr = [NSString stringWithFormat:@"%d:%02d:%02d",hour,minutes,second];
    }
    
}

@end

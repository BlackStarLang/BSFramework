//
//  BSPhotoConfig.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/6/10.
//

#import "BSPhotoConfig.h"

@implementation BSPhotoConfig

+(instancetype)shareConfig{
    
    static BSPhotoConfig *photoConfig = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoConfig = [[BSPhotoConfig alloc]init];
    });
    
    return photoConfig;
}


@end

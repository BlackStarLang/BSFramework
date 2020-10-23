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


-(void)resetAllConfig{
    
    self.allowSelectMaxCount = 9;
    self.currentSelectedCount = 0;
    self.mainColor = nil;
    self.preNaviAlpha = 1;
    self.saveToAlbum = YES;
    self.supCamera = YES;
    self.isOrigin = NO;
    self.mediaType = 0;
}

@end

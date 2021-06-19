//
//  BSVideoPlayerVC.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/6/16.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSVideoPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <UIView+BSView.h>
#import "BSVideoPreLoadManager.h"

@interface BSVideoPlayerVC ()<AVAssetResourceLoaderDelegate>

@property (nonatomic , strong) NSArray *videoUrls;
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , strong) AVPlayerItem *playerItem;
@property (nonatomic , strong) AVPlayerLayer *playerLayer;
@property (nonatomic , strong) UIProgressView *progressView;
@property (nonatomic , strong) BSVideoPreLoadManager *loadManager;
@property (nonatomic , strong) UIButton *playBtn;

@property (nonatomic , assign) BOOL playing;

@property (nonatomic , strong) AVURLAsset *urlAsset;
@end

@implementation BSVideoPlayerVC

-(void)dealloc{
    NSLog(@"BSVideoPlayerVC dealloc");
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self config];
    [self initSubViews];
    [self initFrames];
}


-(void)config{
    
    NSString *url = @"http://img42.ddimg.cn/asset/99538e2e128907ea9ac2c6d13f44c616/play_video/d2f54f53f272f27c377bd072e3a42581.mp4";

    self.loadManager = [[BSVideoPreLoadManager alloc]init];
    
    self.playerItem = [self.loadManager getPlayerItemWithUrls:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playerLayer.player = self.player;
    
    self.playing = YES;
    [self.player play];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self.playerItem forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)initSubViews{
    
    [self.view addSubview:self.playBtn];
    [self.view.layer addSublayer:self.playerLayer];
    [self.view addSubview:self.progressView];
    
    self.progressView.progress = 0.5;

}

-(void)initFrames{
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-100);
        make.centerX.offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    self.playerLayer.frame = CGRectMake(0, 100, SCREEN_WIDTH, 300);
    
    self.progressView.frame = CGRectMake(0, 398, SCREEN_WIDTH, 1);
}


#pragma mark - kvo

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
//    if ([keyPath isEqualToString:@"currentTime"]) {
//        NSValue *curTime = [NSValue valueWithCMTime:self.playerItem.currentTime];
//        NSValue *duration = [NSValue valueWithCMTime:self.playerItem.duration];
//        self.progressView.progress = 0.5;
//    }
}


#pragma mark - action 交互

-(void)playVideo{
    
    if (!self.playing) {
        self.playing = YES;
        [self.player play];
    }else{
        self.playing = NO;
        [self.player pause];
    }
}


#pragma mark - 属性初始化


-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc]init];
        _playerLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    
    return _playerLayer;
}


-(NSArray *)videoUrls{
    if (!_videoUrls) {
        
        NSString *url = @"http://img42.ddimg.cn/asset/4111c68190234858895c131a407f4cc0/play_video/8d691adbcbd54c811c97f64735e744e7.mp4";
        
        NSString *url1 = @"http://img42.ddimg.cn/asset/9487edaa070d609731776b9039b174b2/play_video/fbd74102ad17669b0625f06253859bfb.mp4";
        
        NSString *url2 = @"http://img42.ddimg.cn/asset/eb43e2ced8cfb4e1451210b1369e56bd/play_video/34349bcefb3a5723d5992cfebf47c650.mp4";
        
        _videoUrls = @[url,url1,url2];
    }
    
    return _videoUrls;
}


-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]init];
        _playBtn.backgroundColor = [UIColor blueColor];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.backgroundColor = [UIColor blackColor];
//        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

@end

//
//  BSIKJPlayerController.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/7/5.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//
/// *********************
/// @author lzq
/// @Description  ijkplayer 暂时移除，framework在项目文件夹内，
/// 如需使用，在IJKPlayer 目录下，show in finder,找到ijkpalyer进行 add，
/// 可能需要在设置里配置路径
/// *********************

#import "BSIKJPlayerController.h"
//#import <IJKMediaFramework/IJKMediaFramework.h>
//#import <UIView+BSView.h>


#define IJK_CACHE_PROTOCAL_URL @"ijkio:cache:ffio:"

@interface BSIKJPlayerController ()

//@property(nonatomic,strong)IJKFFMoviePlayerController * player;
//@property(nonatomic,strong)IJKAVMoviePlayerController * avPlayer;
//
//
//@property (nonatomic , strong) UIView *playView;

@end

@implementation BSIKJPlayerController

//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
//
////    [self.view addGestureRecognizer:_resetBottomTapGesture];
////    [self.conversationMessageCollectionView reloadData];
//    //准备播放 （哔哩哔哩）
//    [self.player prepareToPlay];
//    [self.avPlayer prepareToPlay];
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:@"kRCPlayVoiceFinishNotification"
//     object:nil];
//
////    [self.conversationMessageCollectionView removeGestureRecognizer:_resetBottomTapGesture];
////    [self.conversationMessageCollectionView
////     addGestureRecognizer:_resetBottomTapGesture];
//
//    //退出页面，弹幕停止
////    [self.view stopDanmaku];
//    // 停止播放
////    [_txlivePlayer stopPlay];
////    [_txlivePlayer removeVideoWidget]; // 记得销毁view控件
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    //销毁播放器
//    [self.player shutdown];
//    [self.avPlayer shutdown];
//}
//
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//
//    self.playView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
//    self.playView.center = self.view.center;
//    [self.view addSubview:self.playView];
//
//    NSString *url = @"http://img42.ddimg.cn/asset/99538e2e128907ea9ac2c6d13f44c616/play_video/d2f54f53f272f27c377bd072e3a42581.mp4";
//
//    [self addPlayerWithurl:url];
////    [self avFondationWithUrl:url];
//}
//
//
//
//- (void)addPlayerWithurl:(NSString *)url{
//
//    // 创建player
//    //bilibili 播放器
//    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
//
//    // 开启硬件解码 1/0
//    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
//    // 音量大小：256为标准音量
//    [options setPlayerOptionIntValue:256 forKey:@"vol"];
//    // 最大fps
//    [options setPlayerOptionIntValue:30 forKey:@"max-fps"];
//    // 指定最大宽度
//    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
//    // 自动转屏开关
//    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
//    // 重连次数
//    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
//    //超时时间，只对http设置有效
//    [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"];
//
//    // 跳帧开关 ，倍速可以使用此key来控制（可能会引起音视频不同步）
//    [options setPlayerOptionIntValue:0 forKey:@"framedrop"];
//    // 帧速率，建议设定区间为15或者29.97（可能会引起音视频不同步）
//    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
//
//    /// 开启缓存模式
//    NSString *cachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/DangDang/video/test.mp4"];
//    NSString *cachePath2 = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/DangDang/videomap/testmap.tmp"];
//
//    [options setOptionValue:cachePath forKey:@"cache_file_path" ofCategory:kIJKFFOptionCategoryFormat];
//    [options setOptionValue:cachePath2 forKey:@"cache_map_path" ofCategory:kIJKFFOptionCategoryFormat];
//    [options setOptionIntValue:1 forKey:@"parse_cache_map" ofCategory:kIJKFFOptionCategoryFormat];
//    [options setOptionIntValue:1 forKey:@"auto_save_map" ofCategory:kIJKFFOptionCategoryFormat];
//
//    /// 让 url 遵守 ijk 缓存协议 IJK_CACHE_PROTOCAL_URL = @"ijkio:cache:ffio:"
//    NSString *targetUrl = [IJK_CACHE_PROTOCAL_URL stringByAppendingString:url];
//    NSURL *videoURL = [NSURL URLWithString:targetUrl];
//
//    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:videoURL withOptions:options]; //初始化播放器，播放在线视频或直播(RTMP)
//    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.player.view.frame = _playView.bounds;
//    self.player.scalingMode = IJKMPMovieScalingModeAspectFill; //缩放模式
//    self.player.shouldAutoplay = YES; //开启自动播放
//    _playView.autoresizesSubviews = YES;
//    [_playView addSubview:self.player.view];
//}
//
//
//-(void)avFondationWithUrl:(NSString *)url{
//
//    self.avPlayer = [[IJKAVMoviePlayerController alloc]initWithContentURLString:url];
//
//    self.avPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.avPlayer.view.frame = _playView.bounds;
//    self.avPlayer.scalingMode = IJKMPMovieScalingModeAspectFill; //缩放模式
//    self.avPlayer.shouldAutoplay = YES; //开启自动播放
//    _playView.autoresizesSubviews = YES;
//    [_playView addSubview:self.avPlayer.view];
//}
//
//
//- (void)stopBtnDidClicked:(UIButton *)sender{
//    if (!sender.selected) {
//        // 暂停播放
//        [self.player pause];
//    }else{
//        //恢复播放
//        [self.player play];
//    }
//    //改变状态
//    sender.selected = !sender.selected;
//}
//
/////播放状态发生改变时
//- (void)loadStateDidChange:(NSNotification *) notification
//{
//    //状态为缓冲几乎完成，可以连续播放
//    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
//        if (!self.player.isPlaying) {
//            //开始播放
//            [self.player play];
//            [self.avPlayer play];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                [MBProgressHUD hideHUDForView:self.player.view animated:YES];
////                if (_noPlayView.hidden == NO) {
////                    _noPlayView.hidden = YES;
////                }
//            });
//        }else{
//            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                [MBProgressHUD hideHUDForView:self.player.view animated:YES];
////                if (_noPlayView.hidden == NO) {
////                    _noPlayView.hidden = YES;
////                }
//            });
//        }
//    }
//    //缓冲中
//    else if (self.player.loadState & IJKMPMovieLoadStateStalled){
////        [MBProgressHUD showHUDAddedTo:self.player.view animated:YES];
////         [[DataHandle sharedDataHandel]getPlayRoomInfoWithRoomID:self.roomId Block:^(id object) {
////             ///判断是否正在播放
////             if ([((RoomPlayInfoModel *)object).live_status isEqual:@0]) {
////                 //主播不在家  播放状态
////                 _isBiliPlay = NO;
////                 _noPlayView.hidden = NO;
////                 //_noPlayView.hidden = YES;
////             }
////         }];
//        /*
//         这里主播可能已经结束直播了。我们需要请求服务器查看主播是否已经结束直播。
//         方法：
//         1、从服务器获取主播是否已经关闭直播。
//         优点：能够正确的获取主播端是否正在直播。
//         缺点：主播端异常crash的情况下是没有办法通知服务器该直播关闭的。
//         2、用户http请求该地址，若请求成功表示直播未结束，否则结束
//         优点：能够真实的获取主播端是否有推流数据
//         缺点：如果主播端丢包率太低，但是能够恢复的情况下，数据请求同样是失败的。
//         */
//    }
//}


@end

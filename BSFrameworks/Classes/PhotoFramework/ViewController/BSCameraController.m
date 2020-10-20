//
//  BSCameraController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/4/2.
//

#import "BSCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import <Photos/Photos.h>
#import "UIView+BSView.h"
#import "BSVideoBottomView.h"

@interface BSCameraController ()<BSVideoBottomViewDelegate,AVCapturePhotoCaptureDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic ,strong) AVCaptureSession *session;
@property (nonatomic ,strong) AVCaptureDevice *device;
@property (nonatomic ,strong) AVCaptureDeviceInput *deviceInput;//图像输入源
@property (nonatomic ,strong) AVCaptureOutput *outPut;          //图像输出源

@property (nonatomic ,strong) AVCaptureDeviceInput *audioInput; //音频输入源
@property (nonatomic ,strong) AVCaptureAudioDataOutput *audioPutData;   //音频输出源
@property (nonatomic ,strong) AVCaptureVideoDataOutput *videoPutData;   //视频输出源

@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic ,strong) AVCaptureConnection *connection;
@property (nonatomic ,assign) UIDeviceOrientation orientation;

@property (nonatomic ,strong) UIImageView *photoImageView;
@property (nonatomic ,strong) UIButton *ligntBtn;
@property (nonatomic ,strong) UIButton *selfieBtn;

@property (nonatomic ,strong) AVAssetWriter *writer;//视频采集
@property (nonatomic ,strong) AVAssetWriterInput *writerAudioInput;//视频采集
@property (nonatomic ,strong) AVAssetWriterInput *writerVideoInput;//视频采集
@property (nonatomic ,assign) BOOL videoRecording;  //视频正在录制
@property (nonatomic ,assign) BOOL canWritting;     //可以写入
@property (nonatomic ,strong) NSURL *preVideoURL;   //视频预览（存储）地址
@property (nonatomic ,strong) dispatch_queue_t videoQueue;
@property (nonatomic ,strong) dispatch_queue_t audioQueue;

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) AVPlayerLayer *playerLayer;


@property (nonatomic ,strong) BSVideoBottomView *bottomView;

@end


@implementation BSCameraController

#pragma mark - 生命周期

-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isTorchModeSupported:AVCaptureTorchModeOff]) {
            self.device.flashMode = AVCaptureFlashModeOff;
            self.device.torchMode = AVCaptureTorchModeOff;
        }
        [self.device unlockForConfiguration];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self authorization];
}


#pragma mark - 相机授权
-(void)authorization{
    //请求相机权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            __weak typeof(self)weakSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [weakSelf authorization];
                }else{
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"相机权限未开启,请前往手机-设置开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [controller addAction:action];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                    return;
                }
            });
        }];
        
    }else if (status == AVAuthorizationStatusDenied) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"相机权限未开启,请前往手机-设置开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
        
        return;
    }else if (status == AVAuthorizationStatusAuthorized){
        [self configData];
        [self initSubViews];
        [self masonryLayout];
    }
}

#pragma mark - UI 初始化

-(void)initSubViews{
    
    [self.view addSubview:self.photoImageView];
    [self.view addSubview:self.selfieBtn];
    [self.view addSubview:self.ligntBtn];
    [self.view addSubview:self.bottomView];
}


-(void)masonryLayout{

    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.height.mas_equalTo(SCREEN_HEIGHT - 30 - 150);
        make.left.offset(0);
        make.right.offset(0);
    }];

    [self.ligntBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selfieBtn.mas_left).offset(5);
        make.top.offset(0);
        make.height.mas_equalTo(30);
        make.width.offset(40);
    }];

    [self.selfieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(0);
        make.height.mas_equalTo(30);
        make.width.offset(40);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.mas_equalTo(150);
    }];

}

#pragma mark 配置数据(切换拍照类型时，重置输入、输出源)

-(void)configData{
    
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]){
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }else if ([self.session canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
        self.session.sessionPreset = AVCaptureSessionPresetiFrame960x540;
    }

    [self addPicIO];
    [self addVideoIO];

    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 150);
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];


    [self.session startRunning];
}

#pragma mark 设置 拍照类型的输入输出源
-(void)addPicIO{
    NSError *error = nil;

    self.deviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:&error];

    if (!error) {

        if ([self.session canAddInput:self.deviceInput]) {
            [self.session addInput:self.deviceInput];
        }

        if ([self.session canAddOutput:self.outPut]) {
            [self.session addOutput:self.outPut];
        }
    }
}

#pragma mark 设置视频类型的输入输出源
-(void)addVideoIO{

    //视频输出源
    NSDictionary *videoSetting = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};

    self.videoPutData = [[AVCaptureVideoDataOutput alloc]init];
    self.videoPutData.videoSettings = videoSetting;

    self.videoQueue = dispatch_queue_create("vidio", DISPATCH_QUEUE_CONCURRENT);
    [self.videoPutData setSampleBufferDelegate:self queue:self.videoQueue];

    if ([self.session canAddOutput:self.videoPutData]) {
        [self.session addOutput:self.videoPutData];
    }


    //音频输入源
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]firstObject];
    NSError *audioError = nil;
    self.audioInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioDevice error:&audioError];
    if (!audioError) {
        if ([self.session canAddInput:self.audioInput]) {
            [self.session addInput:self.audioInput];
        }
    }

    //音频输出源
    self.audioPutData = [[AVCaptureAudioDataOutput alloc]init];
    if ([self.session canAddOutput:self.audioPutData]) {
        [self.session addOutput:self.audioPutData];
    }

    self.audioQueue = dispatch_queue_create("audio", DISPATCH_QUEUE_CONCURRENT);
    [self.audioPutData setSampleBufferDelegate:self queue:self.audioQueue];

}


#pragma mark - prive method 自定义方法

-(void)setWaterMarkView:(UIView *)waterMarkView{
    _waterMarkView = waterMarkView;

    [self.photoImageView addSubview:waterMarkView];
}


#pragma mark 刷新各个按钮隐藏状态： isRecording 正在拍摄（还未拍）
-(void)refreshBtnsHiddenStatus:(BOOL)isRecording{

    if (isRecording) {
        if (!self.session.isRunning) {
            [self.session startRunning];
        }
    }else{
        if (self.session.isRunning) {
            [self.session stopRunning];
        }
    }

    self.bottomView.typeSelView.hidden = !isRecording;
    self.bottomView.nextBtn.hidden = isRecording;
    self.photoImageView.hidden = isRecording;
    self.bottomView.takeBtn.hidden = !isRecording;
    [self.bottomView.cancelBtn setTitle:isRecording?@"取消":@"重拍" forState:UIControlStateNormal];
}


#pragma mark - action 交互事件

- (void)takePhotoBtnClick{

    if (self.bottomView.typeSelView.selectType == SELECTTYPE_VIDEO) {

        if (self.videoRecording) {
            [self videoStopRecord];
        }else{

            if (self.preVideoURL) {
                NSFileManager *manager = [NSFileManager defaultManager];
                [manager removeItemAtPath:self.preVideoURL.absoluteString error:nil];
            }

            //视频录制
            [self startVideoRecording];
        }

    }else{
        
        if (!self.session.isRunning) {
            [self refreshBtnsHiddenStatus:YES];
        }
        
        if (@available(iOS 10.0, *)) {

            AVCapturePhotoOutput *outPut = (AVCapturePhotoOutput *)self.outPut;

            AVCapturePhotoSettings *settings = [[AVCapturePhotoSettings alloc]init];
            [outPut capturePhotoWithSettings:settings delegate:self];

        }else{

            self.connection = [self.outPut connectionWithMediaType:AVMediaTypeVideo];
            [self.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];

            AVCaptureStillImageOutput *outPut = (AVCaptureStillImageOutput *)self.outPut;

            [outPut captureStillImageAsynchronouslyFromConnection:self.connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

                NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [UIImage imageWithData:jpegData];
                self.photoImageView.image = image;
                [self refreshBtnsHiddenStatus:NO];
            }];
        }

        if ([self.delegate respondsToSelector:@selector(photoCameraTakeBtnClicked)]) {
            [self.delegate photoCameraTakeBtnClicked];
        }

    }
}


-(void)cancelBtnClick{

    if ([self.bottomView.cancelBtn.titleLabel.text isEqualToString:@"重拍"]) {
        [self refreshBtnsHiddenStatus:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)nextBtnClick{
    /// 存到相册
    if (self.saveToAlbum) {
        [self saveWaterMarkImage:[self getWaterMarkImageWithOriginImage:self.photoImageView.image]];
    }else{
        [self delegateCallBack];
    }
}

-(void)delegateCallBack{

    if ([self.delegate respondsToSelector:@selector(photoCameraNextBtnClickedWithImage:)]) {

        UIImage *image = [self getWaterMarkImageWithOriginImage:self.photoImageView.image];
        [self.delegate photoCameraNextBtnClickedWithImage:image];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

/// 闪光灯
-(void)ligntBtnClick{

    if ([self.device lockForConfiguration:nil]) {

        if ([self.device hasTorch] && [self.device hasFlash]) {

            if (self.device.flashMode == AVCaptureFlashModeAuto) {

                if ([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
                    self.device.flashMode = AVCaptureFlashModeOn;
                    self.device.torchMode = AVCaptureTorchModeOn;
                }

                [self.ligntBtn setImage:[UIImage imageNamed:@"photo_camera_light_on"] forState:UIControlStateNormal];

            }else if (self.device.flashMode == AVCaptureFlashModeOn){

                if ([self.device isTorchModeSupported:AVCaptureTorchModeOff]) {
                    self.device.flashMode = AVCaptureFlashModeOff;
                    self.device.torchMode = AVCaptureTorchModeOff;
                }
                [self.ligntBtn setImage:[UIImage imageNamed:@"photo_camera_light_off"] forState:UIControlStateNormal];

            }else{

                if ([self.device isTorchModeSupported:AVCaptureTorchModeAuto]) {
                    self.device.flashMode = AVCaptureFlashModeAuto;
                    self.device.torchMode = AVCaptureTorchModeAuto;
                }
                [self.ligntBtn setImage:[UIImage imageNamed:@"photo_camera_light_auto"] forState:UIControlStateNormal];
            }
        }
        [self.device unlockForConfiguration];
    }
}


/// 自拍
-(void)selfieBtnClick{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *frontDevcie = nil;
    AVCaptureDevice *backDevice = nil;
    
    for (AVCaptureDevice *device in devices) {
        
        if (device.position == AVCaptureDevicePositionFront) {
            frontDevcie = device;
        }else if (device.position == AVCaptureDevicePositionBack){
            backDevice = device;
        }else{
            
        }
    }
    
    if (backDevice && frontDevcie) {
        
        [self.session stopRunning];
        [self.session removeInput:self.deviceInput];
        
        if (self.device.position  == AVCaptureDevicePositionFront) {
            self.device = backDevice;
        }else{
            self.device = frontDevcie;
        }
        
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithFrame:self.previewLayer.bounds];
        blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        [self.view addSubview:blurView];
        
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        }completion:^(BOOL finished) {
            
            [blurView removeFromSuperview];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSError *error = nil;
            self.deviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:&error];
            
            if (!error && [self.session canAddInput:self.deviceInput]) {
                [self.session addInput:self.deviceInput];
            }
        });
        
        [self.session startRunning];
    }
}


#pragma mark - priveDelegate 私有代理

-(void)BSVideoBottomView:(BSVideoBottomView *)bottomView didSelectType:(SELECTTYPE)selectType{

    // 切换拍照类型时，使用毛玻璃效果过渡
    CGRect blurFrame = CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 150);
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithFrame:blurFrame];
    blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    blurView.alpha = 0;
    [self.view addSubview:blurView];
    
    if (selectType == SELECTTYPE_PIC) {
        self.previewLayer.frame = blurFrame;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        blurView.alpha = 1;
    }];
    
    // 延迟 0.2 是为了 self.previewLayer.frame = blurFrame;
    // 生效后再执行毛玻璃alpha动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.2 animations:^{
                blurView.alpha = 0;
            } completion:^(BOOL finished) {
                [blurView removeFromSuperview];
                
                if (selectType == SELECTTYPE_VIDEO) {
                    self.previewLayer.frame = self.view.bounds;
                }
            }];
        });
    });
}


-(void)BSVideoBottomView:(BSVideoBottomView *)bottomView didClickFuncBtnWithType:(FUNCTYPE)funcType{

    if (funcType == FUNC_TYPE_BACK) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];

    }else if (funcType == FUNC_TYPE_RETRY){
        //重拍
        [self refreshBtnsHiddenStatus:YES];
        
    }else if (funcType == FUNC_TYPE_NEXT){
        //下一步
        if ([self.delegate respondsToSelector:@selector(photoCameraNextBtnClickedWithImage:)]) {
            [self.delegate photoCameraNextBtnClickedWithImage:self.photoImageView.image];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (funcType == FUNC_TYPE_PIC_RECORDED){
        
        //拍照
        [self takePhotoBtnClick];
        
    }else if (funcType == FUNC_TYPE_VIDEO_RECORDING){
        
        //开始录制
        [self takePhotoBtnClick];
        
    }else if (funcType == FUNC_TYPE_VIDEO_RECORDED){
        
        //录制结束
        [self videoStopRecord];
    }
    
}



#pragma mark - systemDelegate

//视频录制回调
-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    if (!self.videoRecording) {
        return;
    }

    self.connection = nil;

    CMFormatDescriptionRef desMedia = CMSampleBufferGetFormatDescription(sampleBuffer);
    CMMediaType mediaType = CMFormatDescriptionGetMediaType(desMedia);

    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

    if (!self.canWritting) {
        self.canWritting = YES;
        [self.writer startWriting];
        [self.writer startSessionAtSourceTime:timestamp];
        NSLog(@"====== 运行  startSessionAtSourceTime ======");
    }

    if (mediaType == kCMMediaType_Video) {

        if (self.writerVideoInput.readyForMoreMediaData) {
            BOOL success = [self.writerVideoInput appendSampleBuffer:sampleBuffer];
            if (!success) {
                NSLog(@"video write failed");
            }
        }

    }else if (mediaType == kCMMediaType_Audio){

        if (self.writerAudioInput.readyForMoreMediaData) {
            BOOL success = [self.writerAudioInput appendSampleBuffer:sampleBuffer];
            if (!success) {
                NSLog(@"audio write failed");
            }
        }

    }else{
        NSLog(@"%d",mediaType);
    }
}



-(void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error API_AVAILABLE(ios(10.0)){

    if (photoSampleBuffer) {
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        UIImage *image = [UIImage imageWithData:data];
        self.photoImageView.image = image;

        [self refreshBtnsHiddenStatus:NO];
    }
}

#pragma mark - 视频存储相关

-(void)startVideoRecording{

    dispatch_queue_t writeQueueCreate = dispatch_queue_create("writeQueueCreate", DISPATCH_QUEUE_CONCURRENT);

    __weak typeof(self)weakSelf = self;
    dispatch_async(writeQueueCreate, ^{

        NSError *error = nil;
        weakSelf.preVideoURL = [self getVideoURL];

        weakSelf.writer = [AVAssetWriter assetWriterWithURL:weakSelf.preVideoURL fileType:AVFileTypeMPEG4 error:&error];

        if (!error) {

            NSInteger numPixels = SCREEN_WIDTH * SCREEN_HEIGHT;
            //每像素比特
            CGFloat bitsPerPixel = 12.0;
            NSInteger bitsPerSecond = numPixels * bitsPerPixel;

            // 码率和帧率设置
            NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                                     AVVideoExpectedSourceFrameRateKey : @(15),
                                                     AVVideoMaxKeyFrameIntervalKey : @(10),
                                                     AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel };

            //视频属性
            NSDictionary *videoSetting = @{ AVVideoCodecKey : AVVideoCodecH264,
                                            AVVideoWidthKey : @(SCREEN_HEIGHT * 2),
                                            AVVideoHeightKey : @(SCREEN_WIDTH * 2),
                                            AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                            AVVideoCompressionPropertiesKey : compressionProperties };

            NSDictionary *audioSetting = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                            AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                            AVNumberOfChannelsKey : @(1),
                                            AVSampleRateKey : @(22050) };

            weakSelf.writerAudioInput = [[AVAssetWriterInput alloc]initWithMediaType:AVMediaTypeAudio outputSettings:audioSetting];
            weakSelf.writerAudioInput.expectsMediaDataInRealTime = YES;

            weakSelf.writerVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSetting];
            weakSelf.writerVideoInput.expectsMediaDataInRealTime = YES;

            weakSelf.writerVideoInput.transform = CGAffineTransformMakeRotation(M_PI/2.0);

            if ([weakSelf.writer canAddInput:weakSelf.writerAudioInput]) {
                [weakSelf.writer addInput:weakSelf.writerAudioInput];
            }

            if ([weakSelf.writer canAddInput:weakSelf.writerVideoInput]) {
                [weakSelf.writer addInput:weakSelf.writerVideoInput];
            }

            weakSelf.videoRecording = YES;

        }else{
            NSLog(@"write 初始化失败：%@",error);
        }

    });
}


-(NSURL *)getVideoURL{

    NSString *documentPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/shortVideo"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    destDateString = [destDateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    destDateString = [destDateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    destDateString = [destDateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *videoName = [destDateString stringByAppendingString:@".mp4"];

    NSString *filePath = [documentPath stringByAppendingFormat:@"/%@",videoName];

    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([manager fileExistsAtPath:documentPath isDirectory:&isDir]) {
        if (!isDir) {
            [manager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }else{
        [manager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [NSURL fileURLWithPath:filePath];
}


-(void)videoStopRecord{

    self.canWritting = NO;
    self.videoRecording = NO;
    [self.session stopRunning];
    
    __weak typeof(self)weakSelf = self;

    dispatch_queue_t writeQueue = dispatch_queue_create("writeQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(writeQueue, ^{

        if (weakSelf.writer.status == AVAssetWriterStatusWriting) {

            [weakSelf.writer finishWritingWithCompletionHandler:^{

                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf previewVideo];
                    [weakSelf saveVideoToAlbum:weakSelf.preVideoURL.absoluteString];
                });
            }];
        }
    });
}

//videoPath为视频下载到本地之后的本地路径

- (void)saveVideoToAlbum:(NSString*)videoPath{

    if(videoPath) {

        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);

        if(compatible){
            NSError *error ;
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath,self,@selector(savedVideoPhotoImage:didFinishSavingWithError:contextInfo:),&error);
        }
    }
}

//保存视频完成之后的回调

- (void)savedVideoPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo: (void*)contextInfo {

    if(error) {
        NSLog(@"保存视频失败%@", error);
    }else{
        NSLog(@"保存视频成功");
    }
}


-(void)previewVideo{

    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:view];

    self.playerItem = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:self.preVideoURL]];

    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];

    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = view.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [view.layer addSublayer:self.playerLayer];

    [self.player play];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


-(void)moviePlayDidEnd:(NSNotification*)notification{

    AVPlayerItem*item = [notification object];

    [item seekToTime:kCMTimeZero];

    [self.player play];
}


#pragma mark - 图片存储相关
-(UIImage *)getWaterMarkImageWithOriginImage:(UIImage *)originImage{

    UIGraphicsBeginImageContextWithOptions(self.photoImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.photoImageView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


-(void)saveWaterMarkImage:(UIImage *)waterMarkImage{

    UIImageWriteToSavedPhotosAlbum(waterMarkImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}



-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

    if(error){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self delegateCallBack];
    }
}




#pragma mark - init 属性初始化


-(AVCaptureDevice *)device{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
    }
    return _device;
}


-(AVCaptureOutput *)outPut{
    
    if (!_outPut) {
        if (@available(iOS 10.0, *)) {
            _outPut = [[AVCapturePhotoOutput alloc]init];
        } else {
            _outPut = [[AVCaptureStillImageOutput alloc]init];
            NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
            [(AVCaptureStillImageOutput *)_outPut setOutputSettings:outputSettings];
        }
    }
    return _outPut;
}

-(UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.hidden = YES;
    }
    return _photoImageView;
}



-(UIButton *)ligntBtn{
    if (!_ligntBtn) {
        _ligntBtn = [[UIButton alloc]init];
        _ligntBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _ligntBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_ligntBtn setImage:[UIImage imageNamed:@"photo_camera_light_off"] forState:UIControlStateNormal];
        [_ligntBtn addTarget:self action:@selector(ligntBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ligntBtn;;
}

-(UIButton *)selfieBtn{
    if (!_selfieBtn) {
        _selfieBtn = [[UIButton alloc]init];
        _selfieBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _selfieBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_selfieBtn setImage:[UIImage imageNamed:@"photo_camera_selfie"] forState:UIControlStateNormal];
        [_selfieBtn addTarget:self action:@selector(selfieBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfieBtn;;
}

-(BSVideoBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BSVideoBottomView alloc]init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}



@end

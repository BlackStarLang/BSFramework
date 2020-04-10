//
//  BSCameraController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/4/2.
//

#import "BSCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface BSCameraController ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic ,strong) AVCaptureSession *session;
@property (nonatomic ,strong) AVCaptureDevice *device;
@property (nonatomic ,strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic ,strong) AVCaptureOutput *outPut;
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic ,strong) AVCaptureConnection *connection;
@property (nonatomic ,assign) UIDeviceOrientation orientation;

@property (nonatomic ,strong) UIImageView *photoImageView;
@property (nonatomic ,strong) UIButton *takePhotoBtn;

@property (nonatomic ,strong) UIButton *cancelBtn;
@property (nonatomic ,strong) UIButton *nextBtn;

@property (nonatomic ,strong) UIButton *ligntBtn;
@property (nonatomic ,strong) UIButton *selfieBtn;

@end

@implementation BSCameraController

#pragma mark - 生命周期

-(void)dealloc{
    NSLog(@"==== %@ dealloc =====",NSStringFromClass([self class]));
    
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
    [self.session startRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self authorization];
    [self masonryLayout];
}

-(void)authorization{
    //请求相机权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self authorization];
            }else{
                NSLog(@"无权限");
                return;
            }
        }];
        
    }else if (status == AVAuthorizationStatusDenied) {
        NSLog(@"无权限");
        return;
    }else if (status == AVAuthorizationStatusAuthorized){
        NSLog(@"相机权限已开启");
        [self initSubViews];
    }
}

-(void)initSubViews{
            
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.view addSubview:self.photoImageView];
    [self.view addSubview:self.takePhotoBtn];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.ligntBtn];
    [self.view addSubview:self.selfieBtn];
    
    [self configData];
}

-(void)masonryLayout{
    
    self.previewLayer.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 25 - 150);
   
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.height.mas_equalTo(self.view.frame.size.height - 25 - 150);
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
    
    
    [self.takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.height.mas_equalTo(80);
        make.bottom.offset(-40);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takePhotoBtn.mas_left).offset(-(self.view.frame.size.width/2 - 40)/2);
        make.centerY.equalTo(self.takePhotoBtn);
        make.height.mas_equalTo(30);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takePhotoBtn.mas_right).offset((self.view.frame.size.width/2 - 40)/2);
        make.centerY.equalTo(self.takePhotoBtn);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark 配置数据

-(void)configData{
    
    NSError *error = nil;
    
    self.deviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:&error];
    
    if (!error) {
        if ([_session canAddInput:self.deviceInput]) {
            [_session addInput:self.deviceInput];
        }
        
        if ([_session canAddOutput:self.outPut]) {
            [_session addOutput:self.outPut];
        }
    }
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

    self.nextBtn.hidden = isRecording;
    self.photoImageView.hidden = isRecording;
    self.takePhotoBtn.hidden = !isRecording;
    [self.cancelBtn setTitle:isRecording?@"取消":@"重拍" forState:UIControlStateNormal];
}


#pragma mark - action 交互事件

- (void)takePhotoBtnClick{

    if (!self.session.isRunning) {
        [self refreshBtnsHiddenStatus:YES];
        return;
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
}


-(void)cancelBtnClick{
 
    if ([self.cancelBtn.titleLabel.text isEqualToString:@"重拍"]) {
        [self refreshBtnsHiddenStatus:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.session stopRunning];
    }
}


-(void)nextBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(photoCameraNextBtnClickedWithImage:)]) {
        
        UIImage *image = [self getWaterMarkImageWithOriginImage:self.photoImageView.image];
        [self.delegate photoCameraNextBtnClickedWithImage:image];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.session stopRunning];

}

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


#pragma mark - systemDelegate

-(void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error API_AVAILABLE(ios(10.0)){
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    self.photoImageView.image = image;

    [self refreshBtnsHiddenStatus:NO];
     
}

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
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}




#pragma mark - init 属性初始化

-(AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]){
            _session.sessionPreset = AVCaptureSessionPresetHigh;
        }else if ([_session canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            _session.sessionPreset = AVCaptureSessionPresetiFrame960x540;
        }
    }
    return _session;
}


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

-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _previewLayer;
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

-(UIButton *)takePhotoBtn{
    if (!_takePhotoBtn) {
        _takePhotoBtn = [[UIButton alloc]init];
        [_takePhotoBtn setImage:[UIImage imageNamed:@"photo_camera_take"] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoBtn;;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;;
}


-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        _nextBtn.hidden = YES;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;;
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



@end

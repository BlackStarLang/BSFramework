# 由于项目长时间未更新，导致各种适配问题，请有需要的先不要使用pod组件，相关功能请查看源码，在源码基础上更改方可使用。对于此项目的适配、修复等问题本人将尽量腾出时间来处理，对带来的不便表示十分抱歉。（换了工作一年了，一直都是处于忙碌状态 😅😅😅）
# BSFrameworks (修复的问题没有来得及发pod，如果项目中使用,请暂时直接使用源码)
## version  0.1.10

##### BSFrameworks 是个人用于学习iOS各个知识点的产物，内部含有个人学习所用的部分demo。在此期间，根据所学封装了一些常用控件，已经封装为pod组件，并用于实际产品中。由于产品需求原因，有些组件功能比较单一，不符合通用性，但大部分功能都经过了扩展，开放性较强。封装组件没有经过专业性测试，可能含有bug，如遇问题，请通过邮箱联系我，我会以最快速度修复 ：blackstar_lang@163.com 。此项目将持续到本人退出IT界，否则将一直更新维护，速度可能偏慢，但不会放弃。预计退休时间：黄金被劝退时间35岁，2025年。

[![CI Status](https://img.shields.io/travis/blackstar_lang@163.com/BSFrameworks.svg?style=flat)](https://travis-ci.org/blackstar_lang@163.com/BSFrameworks)
[![Version](https://img.shields.io/cocoapods/v/BSFrameworks.svg?style=flat)](https://cocoapods.org/pods/BSFrameworks)
[![License](https://img.shields.io/cocoapods/l/BSFrameworks.svg?style=flat)](https://cocoapods.org/pods/BSFrameworks)
[![Platform](https://img.shields.io/cocoapods/p/BSFrameworks.svg?style=flat)](https://cocoapods.org/pods/BSFrameworks)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BSFrameworks is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

## 项目包含两部分 

- 学习知识点Demo

- CocoaPods 组件

## 学习的所有知识点 Demo 
#### Demo for study Objective-C

*测试结果还有总结、注意的点，都在注释当中*

*The test results are all in the comments*

- RunTime
- RunLoop
- GCD + NSOperation (多线程)
- method forwarding （消息转发机制）
- NSTimer （定时器强引用问题及解决办法：NSProxy 消息转发）
- AutoreleasePool (自动释放池)
- DynamicBehavior (动态行为)
- Transition Animator （转场动画，模仿 AlertController）
- KVO （原理探究，自定义KVO）
- Socket （基于socket 的简单通信，需要配合后台：Python服务端socket (需要 python 3.0 ，2.7版本的utf-8没处理，会报错)）
- Some Algorithms (学习的几个算法，面试中被提问的，还有网上看的)
- Category (分类，研究了下方法执行顺序，但是没写注释，没写测试结果)


## CocoaPods 组件
#### usege

所有 功能
```ruby
pod 'BSFrameworks'
```
```ruby
1、图片选择器，支持选择图片和视频、图片预览和视频预览、原图选择、相机拍照和视频拍摄

2、图片预览控件，支持URL，PATH，IMAGE，支持混合预览

3、水印相机：使用AVFoundation框架自定义相机，（仅支持拍照后图片添加自定义水印视图），支持视频拍摄

4、轮播图：'2D/3D'

```

轮播图
```ruby
pod 'BSFrameworks/BSLooperView'
```

``` ruby
功能简介：

2D/3D 效果，支持设置3D缩放级别

支持无限轮播，支持自动轮播，支持自动轮播时间间隔设置，支持自动轮播时的滚动方向

支持间距调整，支持缩放后设置中心item两边的item设置中心偏移量

支持collectionView滚动方向

支持自定义cell

```

```ruby
-(BSLooperView *)looperView{
    if (!_looperView) {
        
        _looperView = [[BSLooperView alloc]initWithFrame:CGRectMake(20, 300, self.view.width - 40, 180)];
        _looperView.cellName = @"BSCollectionViewCell";
        _looperView.delegate = self;
        _looperView.itemSize = CGSizeMake(self.view.width - 70 ,180);
        _looperView.scale = 0.6;
        _looperView.isInfinite = YES;
        _looperView.autoLoop = YES;
        _looperView.duration = 1;
        
        _looperView.loopStyle = BSLOOP_STYLE_CARD;

        //卡片样式只支持横向，不支持纵向
        _looperView.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //卡片样式只支持左右，不支持上下
        _looperView.looperPosition = BSLooperPositionLeft;
       
        // visibleCount 卡片样式独有属性
        _looperView.visibleCount = 4;

        // 卡片样式，minimumLineSpacing 无效
        _looperView.minimumLineSpacing = 10;
        
        // 卡片样式，centerOffset 无效
        _looperView.centerOffset = -45;

    }
    return _looperView;
}

/// dataArr 需要最后设置，否则_looperView的样式属性将不生效
self.looperView.dataArr = self.dataArr;
```

图片选择器、图片预览控件、水印相机
```ruby
pod 'BSFrameworks/BSPhotoFramework'
```

``` ruby
功能简介：

1、图片选择器，支持选择图片、图片预览、原图选择、相机拍照

2、图片预览控件，支持URL，PATH，IMAGE，支持混合预览（需要使用预览对象）

3、水印相机：使用AVFoundation框架自定义相机，拍照后图片添加水印
   
0.1.5 版本

1、修复部分bug

2、可选择视频还是照片

3、视频拍摄

4、视频预览

```

```ruby
    /// 整个图片选择控件，包含预览 + 相机  示例
    BSPhotoManagerController *managerVC = [[BSPhotoManagerController alloc]init];
    managerVC.BSDelegate = self;
    managerVC.modalPresentationStyle = 0;
    managerVC.mainColor = [UIColor darkTextColor];
    managerVC.preBarAlpha = 0.7;
    managerVC.currentSelectedCount = 0;
    managerVC.allowSelectMaxCount = 9;
    managerVC.supCamera = YES;
    managerVC.autoPush = YES;
    managerVC.saveToAlbum = YES;
    managerVC.mediaType = 1;
    [self presentViewController:managerVC animated:YES completion:nil];


    /// 图片预览测试 示例
    BSPhotoPreviewController *controller = [[BSPhotoPreviewController alloc]init];
    NSArray *arr = @[[UIImage imageNamed:@"photo_camera_icon"],[UIImage imageNamed:@"preview_video_play"]];

    [controller setPreviewPhotos:[NSMutableArray arrayWithArray:arr] previewType:PREVIEWTYPE_IMAGE defaultIndex:0];
    controller.modalPresentationStyle = 0;
    [self presentViewController:controller animated:YES completion:nil];


    /// 视频预览本地视频 示例
    BSPhotoPreviewVideoVC *vc = [[BSPhotoPreviewVideoVC alloc]init];
    vc.barStyle = UIStatusBarStyleLightContent;
    vc.mainColor = [UIColor blackColor];
    vc.preNaviAlpha = 0.7;
    NSString *test = [[NSBundle mainBundle]pathForResource:@"test" ofType:@".mp4"];
    NSString *test1 = [[NSBundle mainBundle]pathForResource:@"test1" ofType:@".mp4"];
    NSArray *arr1 = @[test,test1];
    [vc setPreviewVideos:[NSMutableArray arrayWithArray:arr1] defaultIndex:0 videoType:VIDEOTYPE_PATH];

    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    navi.modalPresentationStyle = 0;
    [self presentViewController:navi animated:YES completion:nil];
    
    
    /// 自定义相机调用
    /// 水印视图，点击拍照后会显示出来
    /// 之所以这么做是因为公司需求需要，所以水印的逻辑是这样的，但是又懒得优化，就这样吧
    self.waterMarkView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 40, 40)];
    self.waterMarkView.image = [UIImage imageNamed:@"test.jpg"];
    
    BSCameraController *camera = [[BSCameraController alloc]init];
    camera.modalPresentationStyle = 0;
    camera.delegate = self;
    camera.saveToAlbum = YES;
    camera.mediaType = 2;
    camera.waterMarkView = self.waterMarkView;
    [self presentViewController:camera animated:YES completion:nil];

```

## Author

blackstar_lang@163.com, langzq@sqbj.com

## License

BSFrameworks is available under the MIT license. See the LICENSE file for more info.

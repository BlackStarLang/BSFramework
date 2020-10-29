# BSFrameworks 
## version  0.1.4

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


usege

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
        _looperView = [[BSLooperView alloc]initWithFrame:CGRectMake(0, 300, self.view.width, 300)];
        _looperView.cellName = @"BSCollectionViewCell";
        _looperView.delegate = self;
        _looperView.itemSize = CGSizeMake(self.view.width - 120, 100);
        _looperView.minimumLineSpacing = 10;
        _looperView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _looperView.scale = 0.5;
        _looperView.isInfinite = YES;
        _looperView.autoLoop = YES;
        _looperView.centerOffset = -70;
        _looperView.duration = 1;
        _looperView.looperPosition = BSLooperPositionLeft;
    }
    return _looperView;
}

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
BSPhotoManagerController *managerVC = [[BSPhotoManagerController alloc]init];
managerVC.BSDelegate = self;
managerVC.modalPresentationStyle = 0;
managerVC.mainColor = [UIColor darkTextColor];
managerVC.currentSelectedCount = 0;
managerVC.allowSelectMaxCount = 9;
managerVC.supCamera = YES;
managerVC.autoPush = YES;
managerVC.saveToAlbum = YES;
[self presentViewController:managerVC animated:YES completion:nil];

```

## Author

blackstar_lang@163.com, langzq@sqbj.com

## License

BSFrameworks is available under the MIT license. See the LICENSE file for more info.

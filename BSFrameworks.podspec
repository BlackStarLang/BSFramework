#
# Be sure to run `pod lib lint BSFrameworks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSFrameworks'
  s.version          = '0.2.0'
  s.summary          = '轮播图新增 卡片样式(修复图片预览返回按钮UI问题，新增iOS11高版本对应的拍照回调API)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =
 
 <<-DESC

  自己封装的所有的常用工具类
  
  1、图片选择器，支持选择图片、图片预览、原图选择、相机拍照（完成）
     fature:增加选择媒体类型（未开始）
     
  2、图片预览控件，支持URL，PATH，IMAGE，支持混合预览（需要使用预览对象）（完成）
     fature:增加视频预览、视频录制（完成），增加图片缩放、移动、旋转手势（未开始）
     
  3、水印相机：使用AVFoundation框架自定义相机，拍照后图片添加水印（完成）
     fature: 调用相机即添加水印（未开始）
    
  4、轮播图：'2D/3D'（完成）
  
  5、分段控件：segment
  
  
  DESC
  
  s.homepage         = 'https://github.com/BlackStarLang/BSFramework.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'blackstar_lang@163.com' => 'langzq@sqbj.com' }
  s.source           = { :git => 'https://github.com/BlackStarLang/BSFramework.git', :tag => s.version.to_s, :submodules => true}
 
  s.platform         = :ios, "9.0"
  s.ios.deployment_target = '9.0'
  
  s.dependency 'Masonry'
  s.dependency 'SDWebImage'

  
  # 各种分类
  s.subspec 'BSCategory' do |category|
    category.source_files = 'BSFrameworks/Classes/BSCategory/**/*{.h,.m}'
    category.frameworks   = 'AVFoundation','UIKit'
  end
  
  
  # 图片相关：相机、选图、预览等相关功能
  s.subspec 'BSPhotoFramework' do |photoFramework|
    photoFramework.source_files = 'BSFrameworks/Classes/PhotoFramework/**/*{.h,.m}'
    photoFramework.frameworks   = 'Photos','AVFoundation'
    photoFramework.resources    = 'BSFrameworks/Assets/PhotoFramework/*'
    photoFramework.dependency     'BSFrameworks/BSCategory'
  end
  
  
  # 基于collectionview实现的 轮播图，支持2D和3D
  s.subspec 'BSLooperView' do |loopView|
    loopView.source_files = 'BSFrameworks/Classes/BSLooperView/**/*{.h,.m}'
    loopView.frameworks   = 'AVFoundation','UIKit'
    loopView.dependency     'BSFrameworks/BSCategory'
  end

  

#  s.subspec 'BSSocket' do |socket|
#    socket.source_files = 'BSFrameworks/Classes/BSSocket/**/*{.h,.m}'
#    socket.public_header_files = 'BSFrameworks/Classes/BSSocket/BSSocket.h'
#  end

  s.subspec 'BSSocket' do |socket|
    socket.source_files = 'BSFrameworks/Classes/BSSocket/**/*{.h,.m}'
    socket.public_header_files = 'BSFrameworks/Classes/BSSocket/BSSocket.h','BSFrameworks/Classes/BSSocket/**/*{.h}'
  end

  
  s.subspec 'BSVideoPreLoader' do |videoloader|
    videoloader.source_files = 'BSFrameworks/Classes/BSVideoPreLoader/**/*{.h,.m}'
    
  end
  
  s.subspec 'BSSegmentView' do |segmentView|
    segmentView.source_files = 'BSFrameworks/Classes/BSSegment/**/*{.h,.m}'
    segmentView.dependency     'BSFrameworks/BSCategory'
  end
  
  # 上拉下拉刷新控件
#  s.subspec 'BSRefresh' do |ss|
#    ss.source_files = 'BSFrameworks/Classes/BSRefresh/**/*{.h,.m}'
#    ss.frameworks   = 'UIKit'
#    ss.dependency     'BSFrameworks/BSCategory'
#    ss.resources = 'BSFrameworks/Assets/BSRefresh/*'
#    ss.public_header_files = 'BSFrameworks/Assets/BSRefresh/BSRefresh.h'
#  end
  
end

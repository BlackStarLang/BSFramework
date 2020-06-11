#
# Be sure to run `pod lib lint BSFrameworks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSFrameworks'
  s.version          = '0.1.3'
  s.summary          = '紧急修复 UIView+BSView bug'

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
     fature:增加视频预览，增加图片缩放、移动、旋转手势（未开始）
     
  3、水印相机：使用AVFoundation框架自定义相机，拍照后图片添加水印（完成）
     fature: 调用相机即添加水印（未开始）
    
  4、轮播图：'2D/3D'（完成）
  
  
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
  s.subspec 'BSCategory' do |ss|
    ss.source_files = 'BSFrameworks/Classes/BSCategory/**/*{.h,.m}'
    ss.frameworks   = 'AVFoundation','UIKit'
  end
  
  
  # 图片相关：相机、选图、预览等相关功能
  s.subspec 'BSPhotoFramework' do |ss|
    ss.source_files = 'BSFrameworks/Classes/PhotoFramework/**/*{.h,.m}'
    ss.frameworks   = 'Photos','AVFoundation'
    ss.resources    = 'BSFrameworks/Assets/PhotoFramework/*'
    ss.dependency     'BSFrameworks/BSCategory'
  end
  
  
  # 基于collectionview实现的 轮播图，支持2D和3D
  s.subspec 'BSLooperView' do |ss|
    ss.source_files = 'BSFrameworks/Classes/BSLooperView/**/*{.h,.m}'
    ss.frameworks   = 'AVFoundation','UIKit'
    ss.dependency     'BSFrameworks/BSCategory'
  end

  
end

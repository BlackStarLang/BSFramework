#
# Be sure to run `pod lib lint BSFrameworks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSFrameworks'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BSFrameworks.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =
 
 <<-DESC

  自己封装的所有的常用工具类
  1、图片选择器，支持选择图片、视频 (以后可能追加 视频+图片 混合添加的功能)
  2、图片预览控件+视频预览控件
  
  DESC
  
  s.homepage         = 'https://github.com/blackstar_lang@163.com/BSFrameworks'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'blackstar_lang@163.com' => 'langzq@sqbj.com' }
  s.source           = { :git => 'https://github.com/blackstar_lang@163.com/BSFrameworks.git', :tag => s.version.to_s, :submodules => true}
 
  s.platform         = :ios, "9.0"
  s.ios.deployment_target = '9.0'
  s.dependency 'Masonry'

  
  s.subspec 'BSPhotoFramework' do |ss|
    ss.source_files = 'BSFrameworks/Classes/PhotoFramework/**/*{.h,.m}'
    ss.framework    = 'Photos'
    ss.resources    = 'BSFrameworks/Assets/PhotoFramework/*'
  end
  

end

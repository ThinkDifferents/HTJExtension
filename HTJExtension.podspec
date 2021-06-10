
Pod::Spec.new do |s|
  s.name             = 'HTJExtension'
  s.version          = '3.0'
  s.summary          = 'HTJ Extension'

  s.description      = <<-DESC
  添加AF,FD,MB,Masonry,SD,MJ,RAC,LEE,常亮类,HUD分类,链式AF,HUD。
                       DESC

  s.homepage         = 'https://github.com/ThinkDifferents/HTJExtension.git'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ThinkDifferents' => 'm18534353727@163.com' }
  s.source           = { :git => 'https://github.com/ThinkDifferents/HTJExtension.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '8.0'

  s.source_files = 'HTJExtension/Classes/**/*'
  s.resource = ['HTJExtension/Assets/**/*.xcassets']
  
#   s.resource_bundles = {
#     'HTJExtension' => ['HTJExtension/Assets/*.png']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'#, '~> 4.0.1'
  s.dependency 'FDFullscreenPopGesture'
  s.dependency 'MBProgressHUD'
  s.dependency 'Masonry'
  s.dependency 'SDWebImage'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'ReactiveObjC'
  s.dependency 'LEEAlert'
  
end

# 更多参考 https://www.jianshu.com/p/e93cb40a1837

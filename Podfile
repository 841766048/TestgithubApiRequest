platform :ios, '10.0'
use_frameworks!


target 'App' do

#    pod 'RxSwift',    '~> 4.0'
#    pod 'RxCocoa',    '~> 4.0'
    # 自动布局
    pod 'SnapKit',    '~> 5.0.0'
    # json转模型
    pod 'HandyJSON', '~> 5.0.2'
    # 网络请求，类似AFN
    pod "Alamofire", '~> 5.2.0'
		# 网络请求，类似猿题库
    pod 'Moya', '~> 14.0'
    pod 'Moya/RxSwift', '~> 14.0'
    pod 'Moya-ObjectMapper/RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources', '~> 4.0'
    # json转模型
    pod 'SwiftyJSON', '~> 5.0.0'
    # 异步编程库
    pod "PromiseKit", "~> 6.8"
    # 函数式编程辅助方法
    pod 'Dollar', "~> 7.1.0"
    pod 'Cent', "~> 7.0.0"
    # 加载提示
    pod 'NVActivityIndicatorView'
    pod 'NVActivityIndicatorView/Extended'
    
    pod "SwiftyUserDefaults", '~> 5.0'
    
    #图片处理，支持重设尺寸、裁剪、风格化等，目前最高支持swift4.0
    pod 'Toucan'
    # 关于图片下载、缓存的框架，灵感取自于SDWebImage
    pod 'Kingfisher'
    # 提示框
    pod 'MBProgressHUD'
    pod 'ESTabBarController-swift'
    # 全局左滑动
    pod 'SHFullscreenPopGestureSwift'
    pod 'IBAnimatable'
    # Facebook POP 动画
    pod 'pop'
    # 屏幕比例计算
    pod 'AutoInch'
    # 键盘管理
    pod 'IQKeyboardManagerSwift'
    #
    pod 'MJRefresh'
    # 二维码
    pod 'EFQRCode', '~> 5.1.8'
    
    pod 'FMDB'

end



target 'AppTests' do
  pod 'Alamofire'
  pod 'OHHTTPStubs/Swift'
  pod 'SwiftyJSON'
  pod 'FMDB'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end

//
//  ZYCategory.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import Foundation
import HandyJSON
import NVActivityIndicatorView

extension NSObject:HandyJSON{}

//MARK:动画加载提示
extension NSObject : NVActivityIndicatorViewable{
    /// 开启加载提示
    /// - Parameters:
    ///   - size: 动画UI的大小
    ///   - message: 提示内容
    ///   - type: 动画类型
   static func startAnimatingHUD(size:CGSize = CGSize(width: 30,height: 30),
                           message:String = "加载中...",
                           type:NVActivityIndicatorType = .ballSpinFadeLoader){
        startAnimating(size, message: message, type: type,backgroundColor: .clear)
    }
    
    func startAnimatingHUD(size:CGSize = CGSize(width: 30,height: 30),
                            message:String = "加载中...",
                            type:NVActivityIndicatorType = .ballSpinFadeLoader){
        startAnimating(size, message: message, type: type,backgroundColor: .clear)
    }
    /// 停止加载提示
    static func stopAnimatingHUD(){
        stopAnimating()
    }
    
    func stopAnimatingHUD(){
        stopAnimating()
    }
}

extension NSObject {
    /// 是否为模拟器
    var isSimulator: Bool{
        get {
            var isSim = false
            #if arch(i386) || arch(x86_64)
            isSim = true
            #endif
            return isSim
        }
    }
    
    // MARK: - 查找顶层控制器
    /// 获取顶层控制器 根据window
    func appearController() -> (UIViewController?) {
        var window = UIApplication.shared.windows.first
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return appearController(currentVC: vc)
    }
    
    /// 根据控制器获取 顶层控制器
    func appearController(currentVC VC: UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return appearController(currentVC: presentVC)
        }else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return appearController(currentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            return appearController(currentVC:naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }
}

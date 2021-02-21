//
//  AppDelegate.swift
//  App
//
//  Created by 张海彬 on 2020/11/26.
//

import UIKit
import IQKeyboardManagerSwift
import SHFullscreenPopGestureSwift
let logOut = "LogOut" /// 退出登录，更改主视图
let mainInterface = "maininterface" /// 登录成功前往主界面

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let notificationHandler = NotificationHandler()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        keyboardConfiguration()
        shFullscreenPopGestureConfigure()
        setNotification()
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        setupRootController()
        
        return true
    }
    
}
// MARK:根视图设置
extension AppDelegate {
    //MARK: private
    fileprivate func setupRootController() {
        /// 设置主视图
        window?.backgroundColor =  kHexColor(rgb: 0xFCFDFF)
//        let rootController = BaseTabBarController()
        window?.rootViewController = BaseNavigationController(rootViewController: RequestGithubApiVC.init())
        window?.makeKeyAndVisible()
    }
    
    fileprivate func setupLoginVC(){
		// 设置登陆页面视图
    }
}
// MARK:键盘配置
extension AppDelegate {
    fileprivate func keyboardConfiguration(){
        IQKeyboardManager.shared.enable = true // 控制整个功能是否启用
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true // 控制点击背景是否收起键盘
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true; // 控制键盘上的工具条文字颜色是否用户自定义
        IQKeyboardManager.shared.toolbarManageBehaviour = .bySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
        IQKeyboardManager.shared.enableAutoToolbar = true; // 控制是否显示键盘上的工具条
        //    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
        IQKeyboardManager.shared.placeholderFont = kFont(size: 17); // 设置占位文字的字体
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10.auto(); // 输入框距离键盘的距离
        
    }
}
// MARK:添加程序内通知
extension AppDelegate {
    func setNotification(){
        UNUserNotificationCenter.getNotificationState()
        //设置通知代理
        UNUserNotificationCenter.current().delegate = notificationHandler
    }
}

extension AppDelegate {
    /// 配置全局左滑返回手势
    fileprivate func shFullscreenPopGestureConfigure(){
        //启用
        SHFullscreenPopGesture.configure()
    }
    
}

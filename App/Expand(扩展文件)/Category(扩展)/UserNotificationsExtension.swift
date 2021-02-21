//
//  UserNotificationsExtension.swift
//  Swift控件
//
//  Created by 张海彬 on 2020/11/3.
//

import Foundation
import UserNotifications
import UIKit
extension UNUserNotificationCenter{
    /// 请求通知权限
    /// - Parameter block: 成功或者失败回调
    static func requestNotificationPermission(block: @escaping (Bool) -> Void){
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                block(accepted)
                if !accepted {
                    print("用户不允许消息通知。")
                }
            }
    }
    
    
    /// 获取通知状态
    static func getNotificationState(){
        UNUserNotificationCenter.current().getNotificationSettings{
            settings in
            switch settings.authorizationStatus {
            case .authorized:
                NSLog("用户同意通知")
            case .notDetermined:
                UNUserNotificationCenter.requestNotificationPermission{accepted in
                    
                }
            case .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    let alertController = UIAlertController(title: "消息推送已关闭",
                                                            message: "想要及时获取消息。点击“设置”，开启通知。",
                                                            preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                    
                    let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                        (action) -> Void in
                        let url = URL(string: UIApplication.openSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],
                                                          completionHandler: {
                                                            (success) in
                                                          })
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    if let vc = NSObject().appearController() {
                        vc.present(alertController, animated: true, completion: nil)
                    }
                })
            case .provisional:
                fatalError("IOS 12特性")
            case .ephemeral:
                fatalError("IOS 14新特性")
            @unknown default:
                fatalError("不应该出现的原因")
            }
            
            var message = "声音："
            switch settings.soundSetting{
            case .enabled:
                message.append("开启")
            case .disabled:
                message.append("关闭")
            case .notSupported:
                message.append("不支持")
            @unknown default:
                fatalError("不应该出现的原因")
            }
            
            message.append("\n应用图标标记：")
            switch settings.badgeSetting{
            case .enabled:
                message.append("开启")
            case .disabled:
                message.append("关闭")
            case .notSupported:
                message.append("不支持")
            @unknown default:
                fatalError("不应该出现的原因")
            }
            
            message.append("\n在锁定屏幕上显示：")
            switch settings.lockScreenSetting{
            case .enabled:
                message.append("开启")
            case .disabled:
                message.append("关闭")
            case .notSupported:
                message.append("不支持")
            @unknown default:
                fatalError("不应该出现的原因")
            }
            
            message.append("\n在历史记录中显示：")
            switch settings.notificationCenterSetting{
            case .enabled:
                message.append("开启")
            case .disabled:
                message.append("关闭")
            case .notSupported:
                message.append("不支持")
            @unknown default:
                fatalError("不应该出现的原因")
            }
            
            message.append("\n横幅显示：")
            switch settings.alertSetting{
            case .enabled:
                message.append("开启")
            case .disabled:
                message.append("关闭")
            case .notSupported:
                message.append("不支持")
            @unknown default:
                fatalError("不应该出现的原因")
            }
            
            message.append("\n显示预览：")
            if #available(iOS 11.0, *) {
                switch settings.showPreviewsSetting{
                case .always:
                    message.append("始终（默认）")
                case .whenAuthenticated:
                    message.append("解锁时")
                case .never:
                    message.append("从不")
                @unknown default:
                    fatalError("不应该出现的原因")
                }
            } else {
                // Fallback on earlier versions
            }
            
            NSLog(message)
        }
    }
    
    
    /// 获取等待的推送
    /// - Parameter block: 回调
    static func getWaitForNotification(block: @escaping ([UNNotificationRequest]) -> Void){
        UNUserNotificationCenter.current().getPendingNotificationRequests{
            requests in
            block(requests)
        }
    }
    
    /// 获取已经推送过的推送
    /// - Parameter block: 回调
    static func getSendOutNotification(block: @escaping ([UNNotification]) -> Void){
        UNUserNotificationCenter.current().getDeliveredNotifications{
            requests in
            block(requests)
        }
    }
    
    /// 添加/更新通知
    /// - Parameters:
    ///   - identifier: 通知的唯一标识符, 默认使用UUID().uuidString
    ///   - content: 通知内容
    ///   - trigger: 触发条件
    ///   - block: 回调
    static func addUpdateNotification(identifier:String = UUID().uuidString, content:UNMutableNotificationContent, trigger:UNNotificationTrigger, block: ((_ isSuccess:Bool,_ identifier:String) -> Void)? = nil){
        let request = UNNotificationRequest(identifier: identifier,
                                            content:content, trigger:trigger)
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if (block != nil) {
                block!(error == nil, identifier)
            }
        }
    }
    
    
    /// 删除还没有推送的推送
    /// - Parameter identifier: 推送唯一标识符集合
    static func deleteNotification(identifiers:[String]){
        /// 删除identifier 的推送
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    /// 取消全部通知
    static func deleteAllNotification(){
        //取消全部未发送通知
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// 删除已经推送过的特定推送
    /// - Parameter identifiers: 要删除的推送唯一标识符的数组
    static func deleteSendOutNotification(identifiers:[String]){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    /// 删除全部已经推送过的推送
    static func deleteAllSendOutNotification(){
        //取消全部未发送通知
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    //在应用内展示通知(写这个代理，那么程序中就会展示通知弹框)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                    @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        UNUserNotificationCenter.deleteAllSendOutNotification()
//        completionHandler([.sound])
        // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        // completionHandler([])
    }
    
    //对通知进行响应（用户与通知进行交互时被调用）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler:
                                    @escaping () -> Void) {
        //设定Badge数目
        UIApplication.shared.applicationIconBadgeNumber = 0
        print(response.notification.request.content.title)
        print(response.notification.request.content.body)
        //获取通知附加数据
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        //完成了工作
        completionHandler()
    }
}

/**
 如果想要在应用内有提示框
 第一步：在AppDelegate文件里设置一个 静态变量
 let notificationHandler =  NotificationHandler()
 
 第二步：
 在AppDelegate文件中的设置根视图的方法中写上：
 //设置通知代理
 UNUserNotificationCenter.current().delegate = notificationHandler
 
 
 */



//通知的响应回调
extension AppDelegate{
//    iOS10之前的
//    func application(_ application: UIApplication,
//                     didReceive notification: UILocalNotification) {
//        //设定Badge数目
//        UIApplication.shared.applicationIconBadgeNumber = 0
//
//        let info = notification.userInfo as! [String:Int]
//        let number = info["ItemID"]
//        let alertController = UIAlertController(title: "本地通知",
//                                                message: "消息内容：\(String(describing: notification.alertBody))用户数据：\(String(describing: number))",
//                                                preferredStyle: .alert)
//
//
//        let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil);
//
//        alertController.addAction(cancel);
//
//        self.window?.rootViewController!.present(alertController,
//                                                               animated: true, completion: nil)
//    }
}

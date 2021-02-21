//
//  System.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit
import Photos

struct System {
    
    //MARK: APP 版本号
    static var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    //MARK:  APP build 版本号
    static var buildVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    //MARK: 手机系统版本：12.2.4
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    //MARK: 手机系统名称：iPhone OS
    static var systemName: String {
        return UIDevice.current.systemName
    }
    
    //MARK: APP bundle id
    static var bundleId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    //MARK: 设备类型
    static var deviceType: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        if platform == "iPhone1,1" { return "iPhone 2G"}
        if platform == "iPhone1,2" { return "iPhone 3G"}
        if platform == "iPhone2,1" { return "iPhone 3GS"}
        if platform == "iPhone3,1" { return "iPhone 4"}
        if platform == "iPhone3,2" { return "iPhone 4"}
        if platform == "iPhone3,3" { return "iPhone 4"}
        if platform == "iPhone4,1" { return "iPhone 4S"}
        if platform == "iPhone5,1" { return "iPhone 5"}
        if platform == "iPhone5,2" { return "iPhone 5"}
        if platform == "iPhone5,3" { return "iPhone 5C"}
        if platform == "iPhone5,4" { return "iPhone 5C"}
        if platform == "iPhone6,1" { return "iPhone 5S"}
        if platform == "iPhone6,2" { return "iPhone 5S"}
        if platform == "iPhone7,1" { return "iPhone 6 Plus"}
        if platform == "iPhone7,2" { return "iPhone 6"}
        if platform == "iPhone8,1" { return "iPhone 6S"}
        if platform == "iPhone8,2" { return "iPhone 6S Plus"}
        if platform == "iPhone8,4" { return "iPhone SE"}
        if platform == "iPhone9,1" { return "iPhone 7"}
        if platform == "iPhone9,2" { return "iPhone 7 Plus"}
        if platform == "iPhone10,1" { return "iPhone 8"}
        if platform == "iPhone10,4" { return "iPhone 8"}
        if platform == "iPhone10,2" { return "iPhone 8 Plus"}
        if platform == "iPhone10,5" { return "iPhone 8 Plus"}
        if platform == "iPhone10,3" { return "iPhone X"}
        if platform == "iPhone10,6" { return "iPhone X"}
        if platform == "iPhone11,2" { return "iPhone XS"}
        if platform == "iPhone11,4" { return "iPhone XS Max"}
        if platform == "iPhone11,6" { return "iPhone XS Max"}
        if platform == "iPhone11,8" { return "iPhone XR"}
        
        if platform == "iPad1,1" { return "iPad 1"}
        if platform == "iPad2,1" { return "iPad 2"}
        if platform == "iPad2,2" { return "iPad 2"}
        if platform == "iPad2,3" { return "iPad 2"}
        if platform == "iPad2,4" { return "iPad 2"}
        if platform == "iPad2,5" { return "iPad Mini 1"}
        if platform == "iPad2,6" { return "iPad Mini 1"}
        if platform == "iPad2,7" { return "iPad Mini 1"}
        if platform == "iPad3,1" { return "iPad 3"}
        if platform == "iPad3,2" { return "iPad 3"}
        if platform == "iPad3,3" { return "iPad 3"}
        if platform == "iPad3,4" { return "iPad 4"}
        if platform == "iPad3,5" { return "iPad 4"}
        if platform == "iPad3,6" { return "iPad 4"}
        if platform == "iPad4,1" { return "iPad Air"}
        if platform == "iPad4,2" { return "iPad Air"}
        if platform == "iPad4,3" { return "iPad Air"}
        if platform == "iPad4,4" { return "iPad Mini 2"}
        if platform == "iPad4,5" { return "iPad Mini 2"}
        if platform == "iPad4,6" { return "iPad Mini 2"}
        if platform == "iPad4,7" { return "iPad Mini 3"}
        if platform == "iPad4,8" { return "iPad Mini 3"}
        if platform == "iPad4,9" { return "iPad Mini 3"}
        if platform == "iPad5,1" { return "iPad Mini 4"}
        if platform == "iPad5,2" { return "iPad Mini 4"}
        if platform == "iPad5,3" { return "iPad Air 2"}
        if platform == "iPad5,4" { return "iPad Air 2"}
        if platform == "iPad6,3" { return "iPad Pro 9.7"}
        if platform == "iPad6,4" { return "iPad Pro 9.7"}
        if platform == "iPad6,7" { return "iPad Pro 12.9"}
        if platform == "iPad6,8" { return "iPad Pro 12.9"}
        if platform == "iPad6,11" { return "iPad 5"}
        if platform == "iPad6,12" { return "iPad 5"}
        if platform == "iPad7,1" { return "iPad Pro 12.9 inch 2nd gen"}
        if platform == "iPad7,2" { return "iPad Pro 12.9 inch 2nd gen"}
        if platform == "iPad7,3" { return "iPad Pro 10.5"}
        if platform == "iPad7,4" { return "iPad Pro 10.5"}
        if platform == "iPad7,5" { return "iPad 6"}
        if platform == "iPad7,6" { return "iPad 6"}
        
        if platform == "i386"   { return "iPhone Simulator"}
        if platform == "x86_64" { return "iPhone Simulator"}
        
        if platform == "iPod1,1" { return "iPod Touch 1G"}
        if platform == "iPod2,1" { return "iPod Touch 2G"}
        if platform == "iPod3,1" { return "iPod Touch 3G"}
        if platform == "iPod4,1" { return "iPod Touch 4G"}
        if platform == "iPod5,1" { return "iPod Touch 5G"}
        
        return platform
    }
}

/******************* 系统权限 *****************/
extension System{
    //MARK: 相机权限
    static var cameraAuthorized: Bool {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            return true
        }
        return false
    }
    
    //MARK: 照片(相册)权限
    static var photoAuthorized: Bool {
        let status:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        if status == .restricted || status == .denied {
            return false
        }
        return true
    }
    
    //MARK: 跳转到定位服务
    static func openLocationService () {
        if UIApplication.shared.canOpenURL(URL(string: UIApplication.LaunchOptionsKey.location.rawValue)!) {
            if #available(iOS 11.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.LaunchOptionsKey.location.rawValue)!, completionHandler: nil)
            }else{
                UIApplication.shared.openURL(URL(string: UIApplication.LaunchOptionsKey.location.rawValue)!)
            }
            
        }
    }
    
    //MARK: 发短信权限
    static var canSendSMS: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "sms://")!)
    }
    
    //MARK: 打电话权限
    static var canCallPhone: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    }
    
    /// 发短信（发送短信结束后会留在短信界面）
    static func sendSMS(phoneNum: String?) {
        if canSendSMS {
            if let url = URL(string: "sms://" + (phoneNum ?? "")) {
                if #available(iOS 11.0, *) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(url)
                }
                
            }
        }
    }
    
    /// 打电话功能（会直接进行拨打电话,电话结束后会留在电话界面）
    static func openTelphone(phoneNum: String?) {
        if canCallPhone {
            if let url = URL(string: "tel://" + (phoneNum ?? "")) {
                if #available(iOS 11.0, *) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(url)
                }
                
            }
        }
    }
    
    /// 打电话功能（会询问是否拨打电话,电话结束后会返回到应用界面,但是有上架App Store被拒的案例）
    static func openTelpromptPhone(phoneNum: String?) {
        if UIApplication.shared.canOpenURL(URL(string: "telprompt://")!) {
            if let url = URL(string: "telprompt://" + (phoneNum ?? "")) {
                if #available(iOS 11.0, *) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(url)
                }
                
            }
        }
    }
    
    //MARK: 获取设备当前网络IP地址
    static func ipAddress() -> String {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
}


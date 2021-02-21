//
//  UIApplication+Category.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
    
    var currentAppDelegate:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
}

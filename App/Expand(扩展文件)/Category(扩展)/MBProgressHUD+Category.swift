//
//  MBProgressHUD+Category.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit

let HUD_Duration_Infinite = -1
let HUD_Duration_Normal = 1.5
let HUD_Duration_Short = 0.5

extension MBProgressHUD {
    @discardableResult
    class func showAdded(view: UIView, duration showTime: Double, animated: Bool) -> (MBProgressHUD) {
        var animated = animated
//        let existHUD:MBProgressHUD = MBProgressHUD(view: view)
        // 如果有HUD先隐藏掉，保证始终只有一个HUD
        MBProgressHUD.hide(for: view, animated: false)
        // 如果有HUD，则不做animation
        animated = false
        
        let showView = self.showAdded(to: view, animated: animated)

        if Int(showTime) != HUD_Duration_Infinite {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(showTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                MBProgressHUD.hide(for: view, animated: false)
            })
        }
        return showView
    }

    @discardableResult
    class func showAdded(view: UIView, duration showTime: TimeInterval, withText text: String?, animated: Bool) -> (MBProgressHUD) {
        let showView = self.showAdded(view: view, duration: showTime, animated: animated)
        MBProgressHUD(view: view).isUserInteractionEnabled = false
        MBProgressHUD(view: view).mode = .text
        MBProgressHUD(view: view).label.text = text
        MBProgressHUD(view: view).bezelView.color = UIColor.gray
        return showView
    }

    @discardableResult
    class func showAdded(view: UIView, icon image: UIImage?, duration showTime: TimeInterval, withText text: String?, animated: Bool) -> (MBProgressHUD) {
        let showView = self.showAdded(view: view, duration: showTime, animated: animated)
        MBProgressHUD(view: view).isUserInteractionEnabled = false
        MBProgressHUD(view: view).mode = .customView
        return showView
    }
}

private let minHUDWidth: CGFloat = 0.0
extension UIViewController {
    @discardableResult
    func showWaitHUD() -> MBProgressHUD {
        return showWaitHUD(title: "加载中…")
    }

    @discardableResult
    func showWaitHUD(title: String?) -> MBProgressHUD {
        let HUD = showHUD(title: title, duration: TimeInterval(HUD_Duration_Infinite))
        HUD.isUserInteractionEnabled = true
        return HUD
    }

    @discardableResult
    func showHUDWithError(error: String) -> MBProgressHUD {
        return showHUD(title: error , duration: HUD_Duration_Normal)
    }

    @discardableResult
    func showHUD(title: String?) -> MBProgressHUD {
        return showHUD(title: title, duration: HUD_Duration_Normal)
    }

    @discardableResult
    func showHUD(title: String?, detail: String?) -> MBProgressHUD {
        return showHUD(title: title, detail: detail, duration: HUD_Duration_Normal)
    }

    @discardableResult
    func showHUD(title: String?, duration: TimeInterval) -> MBProgressHUD {
        return showHUD(title: "", detail: title, duration: duration)
    }

    @discardableResult
    func showHUD(title: String?, detail: String?, duration: TimeInterval) -> MBProgressHUD {
        var HUD:MBProgressHUD = MBProgressHUD()
        if hudContainerView() != nil {
            HUD = MBProgressHUD.showAdded(view: hudContainerView()!, duration: duration, withText: title, animated: true)
            HUD.detailsLabel.text = detail
            setHUDBelowNavigationBar()
            HUD.minSize = CGSize(width: minHUDWidth, height: 0.0)

        }
        return HUD
    }

    @discardableResult
    func showHUD(withTitle title: String?, detail: String?, topIcon iconImage: UIImage?, duration: TimeInterval) -> MBProgressHUD {
        let HUD = showHUD(title: title, detail: detail, duration: duration)
        HUD.mode = .customView
        HUD.customView = UIImageView(image: iconImage)
        return HUD
    }

    @discardableResult
    func showHUD(withTitle title: String?, error: Error?) -> MBProgressHUD {
        
        let errorDetail = error?.localizedDescription
        return showHUD(title: title, detail: errorDetail)
    }

    
    func hideHUD() {
        if hudContainerView() != nil {
            MBProgressHUD.hide(for: hudContainerView()!, animated: true)
        }
    }

    @discardableResult
    func hudContainerView() -> UIView? {
        if isViewLoaded {
                if parent != nil && parent != navigationController {
                    return parent?.hudContainerView()
                } else if navigationController?.parent != nil && navigationController?.parent != tabBarController {
                    return navigationController?.parent?.hudContainerView()
                } else {
                    return view
                }
        } else {
            return nil
        }
    }

    func setHUDBelowNavigationBar() {
        if navigationController?.view == hudContainerView() {
            if let navigationBar = navigationController?.navigationBar {
                if let hud = MBProgressHUD.forView((navigationController?.view)!) {
                    navigationController?.view.insertSubview(hud, belowSubview: navigationBar)
                }
                
            }
        }
    }
}
    
extension UIView {
    @discardableResult
    func showWaitHUD() -> MBProgressHUD {
        return showWaitHUD(title: "加载中")
    }
    
    @discardableResult
    func showHUDWithError(error: Error?) -> MBProgressHUD {
        return showHUD(title: error?.localizedDescription, duration: HUD_Duration_Normal)
    }
    
    @discardableResult
    func showWaitHUD(title: String?) -> MBProgressHUD {
        let HUD = showHUD(title: "", detail: title, duration: TimeInterval(HUD_Duration_Infinite))
        HUD.mode = .indeterminate
        HUD.isUserInteractionEnabled = true
        return HUD
    }
    
    @discardableResult
    func showHUD(title: String?) -> MBProgressHUD {
        return showHUD(title: title, duration: HUD_Duration_Normal)
    }
    
    @discardableResult
    func showHUD(title: String?, detail: String?) -> MBProgressHUD {
        return showHUD(title: title, detail: detail, duration: HUD_Duration_Normal)
    }
    
    @discardableResult
    func showHUD(title: String?, duration: TimeInterval) -> MBProgressHUD {
        return showHUD(title: "", detail: title, duration: HUD_Duration_Normal)
    }
    
    @discardableResult
    func showHUD(title: String?, detail: String?, duration: TimeInterval) -> MBProgressHUD {
        let HUD = MBProgressHUD.showAdded(view: self, duration: duration, withText: title, animated: true)
        HUD.mode = .text
        HUD.detailsLabel.text = detail
        return HUD
    }
    
    @discardableResult
    func showHUD(title: String, error: Error) -> MBProgressHUD {
        let errorDetail = error.localizedDescription
        return showHUD(title: title, detail: errorDetail)
    }
    
    @discardableResult
    func showHUD(title: String, detail: String,iconImage: UIImage, duration: TimeInterval) -> MBProgressHUD {
        let HUD = showHUD(title: title, detail: detail, duration: duration)
        HUD.mode = .customView
        HUD.customView = UIImageView(image: iconImage)
        return HUD
    }

    func hideHUD() {
        MBProgressHUD.hide(for: self, animated: true)
    }
    
    @discardableResult
    func currentHUD() -> MBProgressHUD {
        return MBProgressHUD(view: self)
    }

}

//
//  BaseTabBarController.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit
import ESTabBarController_swift

class ESTabBarContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = kHexColor(rgb: 0xAAAAAA)
        highlightTextColor = kHexColor(rgb: 0x5AA0FF)
        titleLabel.font = kFont(size: 10.0)
        //        iconColor = kHexColor(rgb: 0x9092a5)
        //        highlightIconColor = kHexColor(rgb: 0x4A6AFF)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class BaseTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置bar的背景色
        tabBar.barTintColor = UIColor.white
        setTabBarControllers()
        
    }
    // MARK: - private
    fileprivate func setTabBarControllers() {
//        self.addChile(title: "首页", image: "home_normal", selectImage: "home_selected", type: HomeVC.self)
//        self.addChile(title: "待办", image: "order_normal", selectImage: "order_selected", type: OrderVC.self)
//        self.addChile(title: "资源", image: "resources_normal", selectImage: "resources_selected", type: ResourcesVC.self)
//        self.addChile(title: "我的", image: "personal_normal", selectImage: "personal_selected", type: PersonalVC.self)
        
    }

    fileprivate func getNavigationController(className : String) -> BaseNavigationController {
        //动态获取命名空间: 命名空间就是用来区分完全相同的类
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        //swift中字符串转化为一个类
        let claName:AnyClass =  NSClassFromString(namespace + "." + className)!
        
        //指定claName是一个控制器类
        let claVC = claName as! UIViewController.Type
        
        //创建控制器
        let controller = claVC.init()
        
        return BaseNavigationController(rootViewController: controller)
    }

    fileprivate func addChile(title:String,image:String, selectImage:String, type:UIViewController.Type) {
//        let classStr = "HomeVC"
//        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else{
//            NSLog("没有获取到命名空间")
//            return
//        }
//        NSLog("\(nameSpace)")
//
//        //1. 如果ChildVcClass为nil，那么直接返回
//        guard let ChildVcClass = NSClassFromString(nameSpace+"."+classStr) else {
//            NSLog("没有获取到对应的类")
//            return
//        }
//        NSLog("\(ChildVcClass)")
        
        let home = BaseNavigationController(rootViewController: type.init())
        home.navigationItem.title = title
        home.tabBarItem =  UITabBarItem(title: title, image: UIImage(named: image)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectImage)!.withRenderingMode(.alwaysOriginal))
        addChild(home)
    }
}

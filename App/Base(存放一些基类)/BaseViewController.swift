//
//  BaseViewController.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit

class BaseViewController: UIViewController {
    ///willLayoutSubviews方法是否执行完了
    var isWillLayoutSubviews = false
    ///DidLayoutSubviews方法是否执行完了
    var isDidLayoutSubviews = false
    var customNavBar:CustomNavigationBar = {
        let customNavBar = CustomNavigationBar.customNavigationBar()
        customNavBar.bottomLineHidden = true
        customNavBar.barBackgroundColor = .white
        return customNavBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.addSubview(customNavBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏原生导航栏
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(customNavBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 显示原生导航栏
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        isDidLayoutSubviews = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        isWillLayoutSubviews = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("RxSwift:\(RxSwift.Resources.total)")
    }
    
    deinit {
        NSLog("当前页面销毁：Rx计数：\(RxSwift.Resources.total)")
    }
    
}

extension BaseViewController {
    //MARK: private
    /// 设置导航栏默认返回按钮(<)
    fileprivate func setNormalBackItem() {
        navigationItem.hidesBackButton = true;
        let backButton: UIButton = self.backButton()
        let backView = UIView(frame: backButton.bounds)
        backButton.addTarget(self, action: #selector(backItemAction), for: UIControl.Event.touchUpInside)
        backView.addSubview(backButton)
        let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = Theme.screenWidth > 375 ? -20 : -16
        let leftBarButtonItem = UIBarButtonItem(customView: backView)
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtonItem]
    }
    
    /// 导航栏返回按钮
    fileprivate func backButton() -> UIButton {
        let backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        let image = UIImage(named: "navigation_back_normal")
        let imagehighlighted = image?.setTintColor(color: .gray)
        backButton.setImage(image, for: UIControl.State.normal)
        backButton.setImage(imagehighlighted, for: UIControl.State.highlighted)
        
        return backButton;
    }
    
    @objc fileprivate func backItemAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController{
    func configure() {
        /// 意思是让 View 的所有边都紧贴在容器内部
        edgesForExtendedLayout = .all
        /// 设置view视图的背景色
        view.backgroundColor = kHexColor(rgb: 0xF5F7FA)
        /// 设置左滑距离多少才返回
        sh_interactivePopMaxAllowedInitialDistanceToLeftEdge = 30
        /// 设置原生导航栏的背景色
        navigationController?.navigationBar.barTintColor = .white
        /// 设置导航栏返回按钮
        if let vcCount = navigationController?.viewControllers.count, vcCount > 1 {
            // setNormalBackItem()
            customNavBar.wr_setLeftButtonWithImage(normalImage: Image.assets_navigation_back_normal)
            customNavBar.onClickLeftButton = { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

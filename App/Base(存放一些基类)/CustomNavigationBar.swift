//
//  CustomNavigationBar.swift
//  App
//
//  Created by 张海彬 on 2020/12/15.
//

import UIKit

class CustomNavigationBar: UIView {
    
    lazy var backgroundView:UIView = {
        let backgroundView = UIView()
        return backgroundView
    }()
    
    lazy var backgroundImageView:UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.isHidden = true
        return backgroundImageView
    }()
    
    lazy var leftButton:UIButton = {
        let leftButton = UIButton()
        leftButton.imageView?.contentMode = .scaleAspectFill
        leftButton.addTarget(self, action: #selector(leftButtonClick(_:)), for: .touchUpInside)
        return leftButton
    }()
    
    lazy var rightButton:UIButton = {
        let rightButton = UIButton()
        rightButton.imageView?.contentMode = .center
        rightButton.titleLabel?.font = kFont(size: 16)
        rightButton.imageView?.contentMode = .scaleAspectFill
        rightButton.addTarget(self, action: #selector(rightButtonClick(_:)), for: .touchUpInside)
        return rightButton
    }()
    
    lazy var titleLable:UILabel = {
        let titleLable = UILabel()
        titleLable.font = kBoldFont(size: 18.auto())
        titleLable.textColor = .black
        titleLable.textAlignment = .center
        return titleLable
    }()
    
    lazy var bottomLine:UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = kHexColor(rgb: 0xEEEEEE)
        return bottomLine
    }()
    
    var onClickLeftButton:(() -> Void)? = nil
    
    var onClickRightButton:(() -> Void)? = nil
    
    static func customNavigationBar() -> CustomNavigationBar {
        return CustomNavigationBar(frame: CGRect(x: 0, y: 0, width: Theme.screenWidth, height: Theme.navBarHeight+Theme.statusBarHeight))
    }
    /// 标题
    var title:String = ""{
        willSet(newValue){
            self.titleLable.text = newValue
        }
    }
    /// 标题颜色
    var titleLabelColor:UIColor = .black{
        willSet(newValue){
            self.titleLable.textColor = newValue
        }
    }
    /// 标题大小
    var titleLabelFont:UIFont = kFont(size: 18){
        willSet(newValue){
            self.titleLable.font = newValue
        }
    }
    
    /// 导航栏的背景颜色
    var barBackgroundColor:UIColor = .white{
        willSet(newValue){
            self.backgroundView.backgroundColor = newValue
        }
    }
    /// 导航栏背景图片
    var barBackgroundImage:UIImage? = nil {
        willSet(newValue){
            self.backgroundImageView.image = newValue
        }
    }
    /// 分割线是否隐藏
    var bottomLineHidden:Bool = false {
        willSet(newValue){
            self.bottomLine.isHidden = newValue
        }
    }
    /// 透明度
    var backgroundAlpha:CGFloat = 1.0 {
        willSet(newValue){
            self.backgroundView.alpha = newValue
            self.backgroundImageView.alpha = newValue
            self.bottomLine.alpha = newValue
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUI()
        updateFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomNavigationBar {
    func setUI() {
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        addSubview(leftButton)
        addSubview(titleLable)
        addSubview(rightButton)
        addSubview(bottomLine)
    }
    
    func updateFrame() {
        backgroundView.frame = self.bounds
        backgroundImageView.frame = self.bounds
        
        leftButton.snp.makeConstraints {[unowned self] (make) in
            make.left.equalTo(self.snp.left).offset(9.auto())
            make.bottom.equalTo(self.snp.bottom).offset(-11.auto())
            make.width.height.equalTo(22.auto())
        }
        
        rightButton.snp.makeConstraints {[unowned self] (make) in
            make.right.equalTo(self.snp.right).offset(-15.auto())
            make.bottom.equalTo(self.snp.bottom).offset(-11.auto())
            make.width.height.equalTo(22.auto())
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.height.equalTo(25.auto())
            make.bottom.equalTo(self.snp.bottom).offset(-10.auto())
            make.left.equalTo(self.leftButton.snp.right).offset(39.auto())
            make.right.equalTo(self.rightButton.snp.left).offset(-33.auto())
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
}

extension CustomNavigationBar {
    
    
    /// 设置按钮的图片文字
    /// - Parameters:
    ///   - normalImage: 默认点击图片
    ///   - highlightedImage: 默认点击高亮图片
    ///   - title: 按钮文字
    ///   - titleColor: 按钮文字颜色
    func wr_setLeftButtonWithImage( normalImage:UIImage? = nil , highlightedImage:UIImage? = nil, title:String? = nil , titleColor:UIColor? = nil) {
        leftButton.isHidden = false
        leftButton.setImage(normalImage, for: .normal)
        leftButton.setImage(highlightedImage, for: .highlighted)
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(titleColor, for: .normal)
    }
    
    func wr_setRightButtonWithImage( normalImage:UIImage? = nil , highlightedImage:UIImage? = nil, title:String? = nil , titleColor:UIColor? = nil) {
        rightButton.isHidden = false
        rightButton.setImage(normalImage, for: .normal)
        rightButton.setImage(highlightedImage, for: .highlighted)
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
    }
    //按钮实现的方法
    @objc func leftButtonClick(_ button:UIButton){
        if let leftButtonClick =  self.onClickLeftButton {
            leftButtonClick()
        }
    }
    
    @objc func rightButtonClick(_ button:UIButton){
        if let rightButtonClick =  self.onClickRightButton {
            rightButtonClick()
        }
    }
}

//
//  UICustomView.swift
//  App
//
//  Created by 张海彬 on 2020/11/28.
//

import Foundation

class ZHView: AnimatableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAnimatableProperties()    // 加入这一句配置默认属性
    }
    func animate() {
        self.animate(.slide(way: .in, direction: .left),duration: 0.7)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZHLabel: AnimatableLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("ZHLabel")
        self.configureAnimatableProperties()    // 加入这一句配置默认属性
    }
    
    func animate() {
        self.animate(.slide(way: .in, direction: .left),duration: 0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZHImageView: AnimatableImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("ZHImageView")
        self.configureAnimatableProperties()    // 加入这一句配置默认属性
    }
    func animate() {
        self.animate(.slide(way: .in, direction: .left),duration: 0.7)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZHButton: UIButton {
    ///按钮不可点击时候的遮罩层
    var coverView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(coverView)
        coverView.backgroundColor = .white
        coverView.alpha = 0.3
        coverView.isUserInteractionEnabled = true
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        coverView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


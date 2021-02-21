//
//  TextInputCell.swift
//  App
//
//  Created by 张海彬 on 2021/1/21.
//

import UIKit

class TextInputCell: UITableViewCell {

   
    @IBOutlet var textView: KUITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.textContainerInset = UIEdgeInsets(top:15.auto(), left: 15.auto(), bottom: 15.auto(), right: 15.auto())
        textView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class KUITextView:UITextView  {
    fileprivate lazy var placeHolderLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "请输入内容~"
        $0.textColor = UIColor.lightGray
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    
     var placeHolder: String? {
        didSet {
            
            placeHolderLabel.text = placeHolder
        }
    }
    
    
    override var font: UIFont? {
        didSet {
            if font != nil {
                // 让在属性哪里修改的字体,赋给给我们占位label
                placeHolderLabel.font = font
            }
        }
    }
    
    // 重写text
    override var text: String? {
        didSet {
            // 根据文本是否有内容而显示占位label
            placeHolderLabel.isHidden = hasText
        }
    }
    
    // frame
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    // xib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // 添加控件,设置约束
    fileprivate func setupUI() {
        // 监听内容的通知
        NotificationCenter.default.addObserver(self, selector: #selector(KUITextView.valueChange), name: UITextView.textDidChangeNotification, object: nil)
        
        // 添加控件
        addSubview(placeHolderLabel)
        
        // 设置约束,使用系统的约束
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 15))

    }
    
    // 内容改变的通知方法
    @objc fileprivate func valueChange() {
        //占位文字的显示与隐藏
        placeHolderLabel.isHidden = hasText
    }
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 子控件布局
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置占位文字的坐标
        placeHolderLabel.frame.origin.x = 17.auto()
        placeHolderLabel.frame.origin.y = 15.auto()
    }
}

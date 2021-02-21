//
//  UITextView+Category.swift
//  App
//
//  Created by 张海彬 on 2021/1/6.
//

import Foundation
import UIKit
extension UITextField {
    
    func setMaxLimit(_ limit: Int, errorMessage error: String? = nil) {
        self.maxLimit = limit
        self.errorMessage = error
        addTarget(HKInputProtocol.shared, action: HKInputProtocol.shared.textFieldSelector, for: .editingChanged)
    }
    
    private struct RuntimeKey {
        static let maxLimitKey = UnsafeRawPointer.init(bitPattern: "maxLimitKey".hashValue)
        static let errorMessageKey = UnsafeRawPointer.init(bitPattern: "errorMessageKey".hashValue)
    }
    
    internal var maxLimit: Int {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.maxLimitKey!) as! Int
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.maxLimitKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var errorMessage: String? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.errorMessageKey!) as? String
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.errorMessageKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func inputToFitDecimalPad(_ string: String) -> Bool {
        guard keyboardType == .decimalPad else {
            return true
        }
        guard string != "" else {
            return true
        }
        if text == "0" && string != "." {
            text = ""
        } else if (text == nil || text! == "") && string == "." {
            text = "0"
        } else {
            guard let text = text else {
                return true
            }
            guard let index = text.firstIndex(of: ".") else {
                return true
            }
            let subString = text[index ..< text.endIndex]
            guard subString.count < 3 else {
                return false
            }
        }
        return true
    }
}

extension UITextView {
    
    func setMaxLimit(_ limit: Int, errorMessage: String? = nil) {
        self.maxLimit = limit
        self.errorMessage = errorMessage
        self.delegate = HKInputProtocol.shared
    }
    
    private struct RuntimeKey {
        static let maxLimitKey = UnsafeRawPointer.init(bitPattern: "maxLimitKey".hashValue)
        static let errorMessageKey = UnsafeRawPointer.init(bitPattern: "errorMessageKey".hashValue)
        static let placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "placeholderLabelKey".hashValue)
        static let ks_delegateKey = UnsafeRawPointer.init(bitPattern: "ks_delegateKey".hashValue)
    }
    
    weak var ks_delegate: UITextViewDelegate? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.ks_delegateKey!) as? UITextViewDelegate
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.ks_delegateKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var maxLimit: Int {
        get {
            let temp = objc_getAssociatedObject(self, RuntimeKey.maxLimitKey!)
            if temp == nil {
                return 0
            }
            return temp as! Int
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.maxLimitKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var errorMessage: String? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.errorMessageKey!) as? String
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.errorMessageKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    fileprivate func textDidChanged() {
        if placeholder != nil {
            placeholderLabel?.isHidden = (text.lengthOfBytes(using: .utf8) != 0)
        }
        guard maxLimit > 0 else {
            return
        }
        let language = textInputMode?.primaryLanguage
        if language == "zh-Hans"  {
            if markedTextRange == nil && (text?.count)! > maxLimit {
                let index = text!.index(text!.startIndex, offsetBy: maxLimit)
                text = String(text![..<index])
                if errorMessage != nil {
                    NSObject().appearController()?.showHUDWithError(error: errorMessage!)
                }
            }
        } else {
            if text!.count > maxLimit {
                let index = text!.index(text!.startIndex, offsetBy: maxLimit)
                text = String(text![..<index])
                if errorMessage != nil {
                    NSObject().appearController()?.showHUDWithError(error: errorMessage!)
                }
            }
        }
    }
    
    internal var placeholderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.placeholderLabelKey!) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel == nil {
                placeholderLabel = UILabel.init(frame: CGRect.init(x: 3, y: 7, width: textContainer.size.width - textContainer.lineFragmentPadding * 1.5, height: 18))
                placeholderLabel?.numberOfLines = 0
                placeholderLabel?.text = newValue
                placeholderLabel?.font = font
                if maxLimit == 0 {
                    self.delegate = HKInputProtocol.shared
                }
                placeholderLabel?.sizeToFit()
                placeholderLabel?.textColor = UIColor.lightGray
                addSubview(placeholderLabel!)
            }
        }
    }
    
    func clearText() {
        text = ""
        if placeholder != nil {
            placeholderLabel?.isHidden = false
        }
    }
    
}

fileprivate class HKInputProtocol: NSObject {
    
    static let shared = HKInputProtocol()
}

extension HKInputProtocol {
    
    @objc func textFieldTextDidChanged(_ textfield: UITextField) {
        setInputLimit(for: textfield)
    }
    
    func setInputLimit(for textField: UITextField) {
        let length = textField.maxLimit
        let error = textField.errorMessage
        let language = textField.textInputMode?.primaryLanguage
        let text = textField.text
        if language == "zh-Hans"  {
            if textField.markedTextRange == nil && text!.count > length {
                let index = text!.index(text!.startIndex, offsetBy: length)
                textField.text = String(text![..<index])
                if error != nil {
                    NSObject().appearController()?.showHUDWithError(error: error!)
//                    hk_showMessage(error!)
                }
            }
        } else {
            if text!.count > length {
                let index = text!.index(text!.startIndex, offsetBy: length)
                textField.text = String(text![..<index])
                if error != nil {
                    NSObject().appearController()?.showHUDWithError(error: error!)
                }
            }
        }
    }
    
    var textFieldSelector: Selector {
        return #selector(textFieldTextDidChanged(_:))
    }
}

extension HKInputProtocol: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textDidChanged()
        textView.ks_delegate?.textViewDidChange!(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView.returnKeyType == .done else {
            return textView.ks_delegate?.textView?(textView, shouldChangeTextIn: range,replacementText: text) ?? true
        }
        guard text == "\n" else {
            return textView.ks_delegate?.textView?(textView, shouldChangeTextIn: range,replacementText: text) ?? true
        }
        textView.endEditing(true)
        return false
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return textView.ks_delegate?.textViewShouldBeginEditing?(textView) ?? true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.ks_delegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.ks_delegate?.textViewShouldEndEditing?(textView) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.ks_delegate?.textViewDidEndEditing?(textView)
    }
}


//
//  HXPHPicker+Rx.swift
//  App
//
//  Created by 张海彬 on 2020/12/27.
//

import Foundation
import RxSwift
import RxCocoa

class HXPHPickerDelegateProxy: DelegateProxy<HXPHPickerController,HXPHPickerControllerDelegate>,DelegateProxyType,HXPHPickerControllerDelegate {
    
    init(my: HXPHPickerController) {
        super.init(parentObject: my, delegateProxy: HXPHPickerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { (parent) -> HXPHPickerDelegateProxy in
            HXPHPickerDelegateProxy(my: parent)
        }
    }
    
    static func currentDelegate(for object: HXPHPickerController) -> HXPHPickerControllerDelegate? {
        return object.pickerControllerDelegate
    }
    
    static func setCurrentDelegate(_ delegate: HXPHPickerControllerDelegate?, to object: HXPHPickerController) {
        object.pickerControllerDelegate = delegate
    }
    
    override func setForwardToDelegate(_ delegate: DelegateProxy<HXPHPickerController, HXPHPickerControllerDelegate>.Delegate?, retainDelegate: Bool) {
        super.setForwardToDelegate(delegate, retainDelegate: retainDelegate)
    }
}

extension Reactive where Base: HXPHPickerController {
    
    var hXPHPickerControllerDelegate: DelegateProxy<HXPHPickerController,HXPHPickerControllerDelegate>{
        return HXPHPickerDelegateProxy.proxy(for: base)
    }
    /// 选择完成之后调用，单选模式下不会触发此回调
    var didFinishWith:Observable<[HXPHAsset]> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:didFinishWith:_:))).map { (result) -> [HXPHAsset] in
            NSLog(result)
            return result[1] as! [HXPHAsset]
        }
    }
    /// 单选完成之后调用
    var singleFinishWith:Observable<HXPHAsset> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:singleFinishWith:_:))).map { (photoAsset) -> HXPHAsset in
            return photoAsset[1] as! HXPHAsset
        }
    }
    /// 点击了原图按钮
    var didOriginalWith:Observable<Bool> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:didOriginalWith:))).map { (photoAsset) -> Bool in
            return photoAsset[1] as! Bool
        }
    }
    
    /// 是否能够选择cell 不能选择时需要自己手动弹出提示框
    var shouldSelectedAsset:Observable<(HXPHAsset,Int)> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:shouldSelectedAsset:atIndex:))).map { (photo) -> (HXPHAsset,Int) in
            let photoAsset = photo[1] as! HXPHAsset
            let atIndex =  photo[2] as! Int
            return (photoAsset:photoAsset,atIndex:atIndex)
        }
    }
    /// 即将选择 cell 时调用
    var willSelectAsset:Observable<(HXPHAsset,Int)> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:willSelectAsset:atIndex:))).map { (photo) -> (HXPHAsset,Int) in
            let photoAsset = photo[1] as! HXPHAsset
            let atIndex =  photo[2] as! Int
            return (photoAsset:photoAsset,atIndex:atIndex)
        }
    }
    /// 选择了 cell 之后调用
    var didSelectAsset:Observable<(HXPHAsset,Int)> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:didSelectAsset:atIndex:))).map { (photo) -> (HXPHAsset,Int) in
            let photoAsset = photo[1] as! HXPHAsset
            let atIndex =  photo[2] as! Int
            return (photoAsset:photoAsset,atIndex:atIndex)
        }
    }
    
    /// 即将取消了选择 cell
    var willUnselectAsset:Observable<(HXPHAsset,Int)> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:willUnselectAsset:atIndex:))).map { (photo) -> (HXPHAsset,Int) in
            let photoAsset = photo[1] as! HXPHAsset
            let atIndex =  photo[2] as! Int
            return (photoAsset:photoAsset,atIndex:atIndex)
        }
    }
    
    /// 取消了选择 cell
    var didUnselectAsset:Observable<(HXPHAsset,Int)> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:didUnselectAsset:atIndex:))).map { (photo) -> (HXPHAsset,Int) in
            let photoAsset = photo[1] as! HXPHAsset
            let atIndex =  photo[2] as! Int
            return (photoAsset:photoAsset,atIndex:atIndex)
        }
    }
    
    /// 点击取消时调用
    var didCancel:Observable<Void> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(didCancel:))).map { (photo) -> Void in }
    }
    
    /// dismiss后调用
    var didDismissWith:Observable<Void> {
        return hXPHPickerControllerDelegate.methodInvoked(#selector(HXPHPickerControllerDelegate.pickerController(_:didDismissWith:))).map { (photo) -> Void in }
    }
    
    
}

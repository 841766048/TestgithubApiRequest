//
//  NVActivityIndicatorViewable.swift
//  NVActivityIndicatorView
//
// The MIT License (MIT)

// Copyright (c) 2016 Vinh Nguyen

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#if canImport(UIKit)
import UIKit
//import NVActivityIndicatorView

/**
 *  UIViewController conforms this protocol to be able to display NVActivityIndicatorView as UI blocker.
 *
 *  This extends abilities of UIViewController to display and remove UI blocker.
 */
//@available(*, deprecated, message: "")
public protocol NVActivityIndicatorViewable {}

//@available(*, deprecated, message: "")
// where Self: UIViewController
public extension NVActivityIndicatorViewable {

    /// Current status of animation, read-only.
    var isAnimating: Bool { return NVActivityIndicatorPresenter.sharedInstance.isAnimating }

    /**
     Display UI blocker.

     Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.

     - parameter size:                 活动指示器视图的大小。
     - parameter message:              活动指示器视图下显示的消息。
     - parameter messageFont:          活动指标视图下显示的消息字体。
     - parameter type:                 动画类型。
     - parameter color:                活动指示器视图的颜色。
     - parameter padding:              活动指示器视图的填充。
     - parameter displayTimeThreshold: 显示实际显示活动指示器的时间阈值。
     - parameter minimumDisplayTime:   活动指示器的最短显示时间。
     - parameter fadeInAnimation:      淡入动画。
     */
   static func startAnimating(
        _ size: CGSize? = nil,
        message: String? = nil,
        messageFont: UIFont? = nil,
        type: NVActivityIndicatorType? = nil,
        color: UIColor? = nil,
        padding: CGFloat? = nil,
        displayTimeThreshold: Int? = nil,
        minimumDisplayTime: Int? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil,
        fadeInAnimation: FadeInAnimation? = NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION) {
        let activityData = ActivityData(size: size,
                                        message: message,
                                        messageFont: messageFont,
                                        type: type,
                                        color: color,
                                        padding: padding,
                                        displayTimeThreshold: displayTimeThreshold,
                                        minimumDisplayTime: minimumDisplayTime,
                                        backgroundColor: backgroundColor,
                                        textColor: textColor)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, fadeInAnimation)
    }
    
    func startAnimating(
         _ size: CGSize? = nil,
         message: String? = nil,
         messageFont: UIFont? = nil,
         type: NVActivityIndicatorType? = nil,
         color: UIColor? = nil,
         padding: CGFloat? = nil,
         displayTimeThreshold: Int? = nil,
         minimumDisplayTime: Int? = nil,
         backgroundColor: UIColor? = nil,
         textColor: UIColor? = nil,
         fadeInAnimation: FadeInAnimation? = NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION) {
         let activityData = ActivityData(size: size,
                                         message: message,
                                         messageFont: messageFont,
                                         type: type,
                                         color: color,
                                         padding: padding,
                                         displayTimeThreshold: displayTimeThreshold,
                                         minimumDisplayTime: minimumDisplayTime,
                                         backgroundColor: backgroundColor,
                                         textColor: textColor)

         NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, fadeInAnimation)
     }
    
    /**
     Remove UI blocker.

     - parameter fadeOutAnimation: fade out animation.
     */
    static func stopAnimating(_ fadeOutAnimation: FadeOutAnimation? = NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION) {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(fadeOutAnimation)
    }
    func stopAnimating(_ fadeOutAnimation: FadeOutAnimation? = NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION) {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(fadeOutAnimation)
    }
}
#endif

//
//  UIView+Category.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit

// MARK: frame
extension UIView{

    ///获取origin
    var origin:CGPoint {
        get {
            return self.frame.origin
        }
        set(newValue) {
            var rect = self.frame
            rect.origin = newValue
            self.frame = rect
        }
    }
    ///获取size
    var size:CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            var rect = self.frame
            rect.size = newValue
            self.frame = rect
        }
    }
    ///获取x坐标
    var x:CGFloat{
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    ///获取y坐标
    var y:CGFloat{
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    ///获取宽度
    var width:CGFloat{
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.width
        }
    }
    ///获取高度
    var height:CGFloat{
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.height
        }
    }
    ///获取的也是x坐标
    var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    ///获取y坐标
    var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    ///获取x+width
    var right:CGFloat {
        get {
            return (self.frame.origin.x + self.frame.size.width)
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.x = (newValue - self.frame.size.width)
            self.frame = rect
        }
    }
    ///获取y+width
    var bottom:CGFloat {
        get {
            return (self.frame.origin.y + self.frame.size.height)
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = (newValue - self.frame.size.height)
            self.frame = rect
        }
    }
    
    /// 移动到指定中心点位置
    /// - Parameter point: 指定CGPoint位置
    /// - Returns:
    func moveToPoint(point:CGPoint) -> Void{
        var center = self.center
        center.x = point.x
        center.y = point.y
        self.center = center
    }
    
    
    /// 缩放到指定大小
    /// - Parameter scale: 比例
    /// - Returns:
    func scaleToSize(scale:CGFloat) -> Void{
        var rect = self.frame
        rect.size.width *= scale
        rect.size.height *= scale
        self.frame = rect
    }
    
}
//MARK: 圆角
extension UIView{
    /// 圆角边框设置
    /// - Parameters:
    ///   - radius: 圆角值
    ///   - borderWidth: 边框宽
    ///   - borderColor: 边框颜色
    /// - Returns:
    func layer(radius:CGFloat, borderWidth:CGFloat, borderColor:UIColor) -> Void
    {
        if (0.0 < radius)
        {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
            self.clipsToBounds = true
        }
        
        if (0.0 < borderWidth)
        {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    func setBorderWithView(top:Bool,left:Bool,bottom:Bool,right:Bool,width:CGFloat,color:UIColor) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        if top {
            let layer = CALayer()
			layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if left {
			let layer = CALayer()
			layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if bottom {
			let layer = CALayer()
			layer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if right {
            let layer = CALayer()
			layer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

    }
    
    
    
    /// 设置圆角：setCornersRadius(contentBtn, radius: 8.0, roundingCorners: [[.topLeft, .bottomLeft]])
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - roundingCorners: .topLeft, .bottomLeft
    func setCornersRadius( radius: CGFloat, roundingCorners: UIRectCorner,borderWidth:CGFloat = 1, borderColor:UIColor = kHexColor(rgb: 0xDDDDDD)) {
        self.layoutIfNeeded()
        let subLayers = self.layer.sublayers
        
        let removedLayers = subLayers?.filter({ (layer) -> Bool in
            layer.isKind(of: CAShapeLayer.self)
        })
        if let layes = removedLayers {
            for (_, item) in layes.enumerated() {
                item.removeFromSuperlayer()
            }
        }
        
        
        let maskLayer = CAShapeLayer()
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius))
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        
        let borderLayer =  CAShapeLayer()
        borderLayer.path = maskPath.cgPath;
        borderLayer.fillColor = UIColor.clear.cgColor;
        borderLayer.strokeColor = borderColor.cgColor;
        borderLayer.lineWidth = borderWidth;
        borderLayer.frame = self.bounds;
        self.layer.mask = maskLayer;
        self.layer.addSublayer(borderLayer)
    
    }
    
    


}

// MARK: - 翻转
extension UIView{
    // MARK: - 翻转
    /// 旋转 旋转180度 M_PI
    /// - Parameter rotation: 翻转值
    /// - Returns:
    func viewTransformWithRotation(rotation:CGFloat) -> Void
    {
        self.transform = CGAffineTransform(rotationAngle: rotation);
    }
    
    
    /// 缩放
    /// - Parameter size: 缩放到多大
    /// - Returns:
    func viewScaleWithSize(size:CGFloat) -> Void
    {
        self.transform = self.transform.scaledBy(x: size, y: size);
    }
    
    
    /// 水平，或垂直翻转
    /// - Parameter isHorizontal: true：水平翻转 false：垂直翻转
    /// - Returns:
    func viewFlip(isHorizontal:Bool) -> Void
    {
        if (isHorizontal)
        {
            // 水平
            self.transform = self.transform.scaledBy(x: -1.0, y: 1.0);
        }
        else
        {
            // 垂直
            self.transform = self.transform.scaledBy(x: 1.0, y: -1.0);
        }
    }
}

// MARK: - 毛玻璃效果
extension UIView{
    /// 毛玻璃效果
    /// - Parameter alpha: 透明值
    /// - Returns:
    func effectViewWithAlpha(alpha:CGFloat) -> Void
    {
        let effect = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = self.bounds
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// MARK: 分割线
extension UIView {
    func addBroder(frame:CGRect, borderCorlor:UIColor) {
        let layer = CALayer()
        layer.backgroundColor = borderCorlor.cgColor
        layer.frame = frame
        self.layer.addSublayer(layer)
    }
    func addTopBorder(borderWidth:CGFloat, borderCorlor:UIColor) {
        layoutIfNeeded()
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderWidth)
        addBroder(frame: frame, borderCorlor: borderCorlor)
    }
    func addBottomBorder(borderWidth:CGFloat, borderCorlor:UIColor) {
        layoutIfNeeded()
        let frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        addBroder(frame: frame, borderCorlor: borderCorlor)
    }
    func addLeftBorder(borderWidth:CGFloat, borderCorlor:UIColor) {
        layoutIfNeeded()
        let frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        addBroder(frame: frame, borderCorlor: borderCorlor)
    }
    func addRightBorder(borderWidth:CGFloat, borderCorlor:UIColor) {
        layoutIfNeeded()
        let frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        addBroder(frame: frame, borderCorlor: borderCorlor)
    }
}
// MARK: 判断View是否显示在屏幕上
extension UIView{
    
    /// 判断View是否显示在屏幕上
    /// - Returns: true: 在，false：不在
    func isDisplayedInScreen() -> Bool {
        self.layoutIfNeeded()
        let screebRect = UIScreen.main.bounds
        
        // 转换view对应window的Rect
        let rect = self.convert(self.frame, from: nil)
        if (rect.isEmpty || rect.isNull) {
            return false
        }
        // 若view 隐藏
        if self.isHidden {
            return false
        }
        // 若没有superview
        if self.superview == nil {
            return false
        }
        // 若size为CGrectZero
        if __CGSizeEqualToSize(rect.size, CGSize.zero) {
            return false
        }
        
        // 获取 该view与window 交叉的 Rect
        let intersectionRect = rect.intersection(screebRect)
        if (intersectionRect.isEmpty || intersectionRect.isNull) {
            return false
        }
        
        return true
    }
}

extension UIView{
    
    /// 添加横向渐变色
    /// - Parameter colors: 渐变色颜色组
    func addRunWildGradientColor( colors:[UIColor]) {
        if colors.count == 0 {
            return
        }
        let cgColors = colors.map { $0.cgColor }
        let gradient:CAGradientLayer = CAGradientLayer.init()
        gradient.locations = [0.0,0.5 ,1.0]
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1, y: 0.5)
        
        gradient.colors = cgColors;
        gradient.frame = bounds;
        self.layer.insertSublayer(gradient, at: 0)
    }
}


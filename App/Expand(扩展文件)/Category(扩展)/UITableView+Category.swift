//
//  UITableView+Category.swift
//  App
//
//  Created by 张海彬 on 2020/12/25.
//

import Foundation


extension UITableView {
    func sectionFillets(_ cell:UITableViewCell, indexPath:IndexPath) {
        // 圆角角度
        let radius = 10
        // 设置cell 背景色为透明
        cell.backgroundColor = .clear
        // 创建两个layer
        let normalLayer = CAShapeLayer()
        let selectLayer = CAShapeLayer()
        
        // 获取显示区域大小
        var bounds: CGRect = cell.bounds
        bounds = bounds.insetBy(dx: 15.auto(), dy: 0)
        let normalBgView = UIView(frame: bounds)
        
        let rowNum = self.numberOfRows(inSection: indexPath.section)
        var addLine: Bool = false
        var bezierPath:UIBezierPath?
        if rowNum == 1 {
            bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
            normalBgView.clipsToBounds = false
        }else{
            normalBgView.clipsToBounds = true
            if indexPath.row == 0 {
                normalBgView.frame = bounds.inset(by: UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0))
                let rect = bounds.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
                bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners:[.topLeft,.topRight], cornerRadii: CGSize(width: radius, height: radius))
                addLine = true
            }else if (indexPath.row == rowNum - 1){
                normalBgView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0))
                let rect = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
                bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners:[.bottomLeft,.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            }else{
                bezierPath = UIBezierPath(rect: bounds)
                addLine = true
            }
        }
        
        // 阴影
        normalLayer.shadowColor = UIColor.black.cgColor
        normalLayer.shadowOpacity = 0.2
        normalLayer.shadowOffset = CGSize(width: 0, height: 0)
        normalLayer.path = bezierPath?.cgPath
        normalLayer.shadowPath = bezierPath?.cgPath
        
        // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
        normalLayer.path = bezierPath?.cgPath
        selectLayer.path = bezierPath?.cgPath
        
        // 设置填充颜色
        normalLayer.fillColor = UIColor.white.cgColor
        // 添加图层到nomarBgView中
        normalBgView.layer.insertSublayer(normalLayer, at: 0)
        normalBgView.backgroundColor = .clear
        cell.backgroundView = normalBgView
        
        if addLine {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
            lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width - 10.0, height: lineHeight)
            lineLayer.backgroundColor = self.separatorColor?.cgColor
            normalBgView.layer.addSublayer(lineLayer)
        }
        
        
        
        let selectBgView = UIView(frame: bounds)
        selectLayer.fillColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        selectBgView.layer.insertSublayer(selectLayer, at: 0)
        selectBgView.backgroundColor = .clear
        cell.selectedBackgroundView = selectBgView
        
    }
}

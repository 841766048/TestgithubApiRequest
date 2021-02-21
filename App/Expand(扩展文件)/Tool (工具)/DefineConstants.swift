//
//  DefineConstants.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit
//MARK: - Color

/// 根据RGB获取颜色
/// - Parameters:
///   - r: r的值，不需要除255
///   - g: g的值，不需要除255
///   - b: b的值，不需要除255
/// - Returns: 根据RGB获取颜色
func kRGBColor(r: CGFloat,g: CGFloat,b: CGFloat) -> UIColor {
    return kRGBAColor(r: r, g: g, b: b, a: 1)
}

func kRGBAColor(r: CGFloat,g: CGFloat,b: CGFloat,a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


/// 根据十六进制获取颜色
/// - Parameter rgb: 十六进制，如：0xaabbcc
/// - Returns: 根据十六进制获取颜色
func kHexColor(rgb: UInt32) ->UIColor {
    return kHexAColor(rgb: rgb, a: 1)
}

/// 获取随机颜色
/// - Returns: 随机颜色
func kRandomColor () -> UIColor {
    return kRGBAColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)), a: 1.0)
}


/// 根据包含透明度的 十六进制获取颜色
/// - Parameter rgba: 包含透明度的 十六进制 ，如：0xaabbccdd
/// - Returns: 根据包含透明度的 十六进制获取颜色
func kHexColor(rgba: UInt32) ->UIColor {
    return kRGBAColor(r: (CGFloat((rgba & 0xFF000000) >> 24)), g: (CGFloat((rgba & 0xFF0000) >> 16)), b: (CGFloat((rgba & 0xFF00) >> 8)), a: (CGFloat(rgba & 0xFF)))
}

/// 如：0xaabbcc, 0.5
func kHexAColor(rgb: UInt32, a: CGFloat) -> UIColor {
    return kRGBAColor(r: CGFloat(((rgb)>>16) & 0xFF), g: CGFloat(((rgb)>>8) & 0xFF), b: CGFloat((rgb) & 0xFF), a: a)
}

//MARK: Font

func kFont(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size.auto())
}

func kFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
    return UIFont.systemFont(ofSize: size.auto(), weight: weight)
}

func kFont(size: CGFloat, name: String) -> UIFont {
    return UIFont(name: name, size: size.auto()) ?? kFont(size: size.auto())
}

func kBoldFont(size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size.auto())
}

func NSLog( _ conten: Any... ,files:String = #file, funcName:String = #function,linNume:Int = #line){
    // 获取打印所在的文件,转换成NSString，来调用lastPathComponent获取路径最后一个元素
    let file = (files as NSString).lastPathComponent
    // 获取打印所在的方法 #function
    // 获取打印的行数 #line
    #if DEBUG
    print("[文件\(file)=>方法：\(funcName)=>\(linNume)行]:\(conten)")
    #endif
    
}

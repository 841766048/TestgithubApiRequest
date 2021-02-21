//
//  NSString+Category.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit
extension String {
    /// 字符串是否为空
    static func isEmpty(string : Any?) -> Bool {
        guard let str = string as? String else {
            return true
        }
        
        if str.count == 0 || str == "" || str == "null" || str == "(null)" {
            return true
        }
        return false
    }
    
    func sizeWithFont(font: UIFont, maxSize: CGSize) -> CGSize {
        if String.isEmpty(string: self) {
            return CGSize.zero
        }
        let size = self.boundingRect(with: maxSize, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return size
    }
    
    func zy_subString(to index: Int) -> String {
        if self.count > 0 {
            return String(self[..<self.index(self.startIndex, offsetBy: index)])
        }else{
            return self
        }
    }
    
    func zy_subString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    func zy_subString(rang: NSRange) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: rang.location)
        let endIndex = self.index(self.startIndex, offsetBy: (rang.location + rang.length))
        return String(self[startIndex..<endIndex])
    }
    
    /// 字典/数组转二进制
    static func toJSONData(object: Any) -> Data? {
        if (!JSONSerialization.isValidJSONObject(object)) {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        return data
        
    }
    /// 字典/数组转JSON
    static func toJSONString(object: Any) -> String? {
        if let data = toJSONData(object: object) {
            let JSONString = String(data: data, encoding: String.Encoding.utf8)
            return JSONString as String?
        }
        return nil
    }
    
    /// url中文及特殊字符转码
    static func urlEncode(string : String) -> String {
        let charactersToEscape = "!$&'()*+,-./:;=?@_~%#[]"
        let allowedCharacters = NSCharacterSet(charactersIn: charactersToEscape).inverted
        let encodedString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        return encodedString ?? string;
    }
    
    /// 只包含字母和数字的随机字符串
    static func arc4randomString(with length: Int) -> String {
        let letterString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numberString = "0123456789"
        var randomString = ""
        
        for i in 0 ..< length {
            var slicingString: String
            if i <= length / 2 {
                slicingString = letterString
            } else {
                slicingString = numberString
            }
            let index = Int(arc4random() % UInt32(slicingString.count))
            if let c = slicingString.prefix(index).last {
                randomString += String(c)
            }
        }
        
        return randomString
    }
    
    /// 是否为手机号(模糊匹配)
    func isPhoneNum() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "1[0-9][0-9]{9}";
        return self.predicate(with: regex)
    }
    
    /// 是否为邮箱
    func isEmail() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        return self.predicate(with: regex)
    }
    
    /// 是否为身份证号码
    func isIdCard() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$";
        return self.predicate(with: regex)
    }
    
    /// 是否为纯数字
    func isPureNumber() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "[0-9]*";
        return self.predicate(with: regex)
    }
    
    /// 是否为纯字母
    func isPureLetters() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "[a-zA-Z]*";
        return self.predicate(with: regex)
    }
    
    /// 只包含数字和字母
    func isPureNumberOrLetters() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "[a-zA-Z0-9]*";
        return self.predicate(with: regex)
    }
    
    /// 只包含数字和.
    func isPureNumbersOrPoint() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "[0-9.]*";
        return self.predicate(with: regex)
    }
    
    /// 只包含中文
    func isPureChinese(string: String) -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regex = "[\u{4e00}-\u{9fa5}]+"
        return self.predicate(with: regex)
    }
    
    /// 是否包含中文
    func isContainsChinese() -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        
        for value in self {
            if ("\u{4E00}" <= value && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    /// n-m位数字和字母组合
    func checkNumOrLetStrForN(n: Int, to m: Int) -> Bool {
        if String.isEmpty(string: self) {
            return false
        }
        let regx = NSString(format: "^[A-Za-z0-9]{%td,%td}+$", min(n, m), max(n, m)) as String
        return self.predicate(with: regx)
    }
    
    /// 拼音
    func pinYin() -> String {
        if String.isEmpty(string: self) {
            return ""
        }
        //转化为可变字符串
        let mString = NSMutableString(string: self)
        //转化为带声调的拼音
        CFStringTransform(mString, nil, kCFStringTransformToLatin, false)
        //转化为不带声调
        CFStringTransform(mString, nil, kCFStringTransformStripDiacritics, false)
        
        //转化为不可变字符串
        let string = NSString(string: mString)
        //去除字符串之间的空格
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    /// 首字母
    func firstLetter() -> String {
        let pinYin = self.pinYin()
        if !String.isEmpty(string: pinYin) {
            let first = pinYin.zy_subString(rang: NSRange(location: 0, length: 1))
            if first.isPureLetters() {
                return first.uppercased()
            }
            return "#"
        }
        return "#"
    }
    
    /// Range转NSRange
    func toNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    /// NSRange转Range
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    
    /// 时间是否过期，本身是开始结束时间
    /// - Parameter startDate: 开始时间
    /// - Returns: true：没有过期  false：过期
    func isTheTimeExpired(startDate:Date = Date()) -> Bool {
        return self.getTimeDifference(startDate: startDate) > 0
    }
    
    /// 根据结束时间，传开始时间获取两个时间差
    /// - Parameter startDate: 开始时间
    /// - Returns: 时间差值
    func getTimeDifference(startDate:Date = Date()) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let endDate = dateFormatter.date(from: self)
        let startTime = startDate.timeIntervalSince1970
        let endTime = endDate!.timeIntervalSince1970
        return endTime - startTime
    }
}

extension String {
    //MARK: private method
    /// 正则匹配
    fileprivate func predicate(with regex: String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

// MARK:- 八、字符串的一些正则校验
extension String {
    
    // MARK: 8.1、判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    /// 判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    public var isBlank: Bool {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == ""
    }
    
    // MARK: 8.2、判断是否全十进制数字，长度为0返回false
    /// 判断是否全十进制数字，长度为0返回false
    public var isDecimalDigits: Bool {
        if isEmpty {
            return false
        }
        // 去除什么的操作
        return trimmingCharacters(in: NSCharacterSet.decimalDigits) == ""
    }
    
    // MARK: 8.3、判断是否是整数
    /// 判断是否是整数
    public var isPureInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var n: Int = 0
        return scan.scanInt(&n) && scan.isAtEnd
    }
    
    // MARK: 8.4、判断是否是Float,此处Float是包含Int的，即Int是特殊的Float
    /// 判断是否是Float，此处Float是包含Int的，即Int是特殊的Float
    public var isPureFloat: Bool {
        let scan: Scanner = Scanner(string: self)
        var n: Float = 0.0
        return scan.scanFloat(&n) && scan.isAtEnd
    }
    
    // MARK: 8.5、判断是否全是字母，长度为0返回false
    /// 判断是否全是字母，长度为0返回false
    public var isLetters: Bool {
        if isEmpty {
            return false
        }
        return trimmingCharacters(in: NSCharacterSet.letters) == ""
    }
    
    // MARK: 8.6、判断是否是中文, 这里的中文不包括数字及标点符号
    /// 判断是否是中文, 这里的中文不包括数字及标点符号
    public var isChinese: Bool {
        let mobileRgex = "(^[\u{4e00}-\u{9fef}]+$)"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 8.7、是否是有效昵称，即允许“中文”、“英文”、“数字”
    /// 是否是有效昵称，即允许“中文”、“英文”、“数字”
    public var isValidNickName: Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 8.8、判断是否是有效的手机号码
    /// 判断是否是有效的手机号码
    public var isValidMobile: Bool {
        let mobileRgex = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199)\\d{8}$"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 8.9、判断是否是有效的电子邮件地址
    /// 判断是否是有效的电子邮件地址
    public var isValidEmail: Bool {
        let mobileRgex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 8.10、判断是否有效的身份证号码，不是太严格
    /// 判断是否有效的身份证号码，不是太严格
    public var isValidIDCardNumber: Bool {
        let mobileRgex = "^(\\d{15})|((\\d{17})(\\d|[X]))$"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 8.11、严格判断是否有效的身份证号码,检验了省份，生日，校验位，不过没检查市县的编码
    /// 严格判断是否有效的身份证号码,检验了省份，生日，校验位，不过没检查市县的编码
    public var isValidIDCardNumStrict: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.isValidIDCardNumber {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.sub(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位，00被处理为闰年了，对2000年是正确的，对1900年是错误的，不过身份证是1900年的应该很少了
            year = Int(str.sub(start: 6, length: 2))!
            if isLeapYear(year: year) { // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, len))
            
            if numberOfMatch > 0 {
                return true
            } else {
                return false
            }
        case 18:
            // 18位身份证
            year = Int(str.sub(start: 6, length: 4))!
            if isLeapYear(year: year) {
                // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, len))
            if numberOfMatch > 0 {
                var s = 0
                let jiaoYan = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
                for i in 0 ..< 17 {
                    if let d = Int(str.slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.sub(start: Y, length: 1)
                if M == str.sub(start: 17, length: 1) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    // MARK: 8.12、校验字符串位置是否合理，并返回String.Index
    /// 校验字符串位置是否合理，并返回String.Index
    /// - Parameter original: 位置
    /// - Returns: String.Index
    public func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self):
            return startIndex
        case endIndex.utf16Offset(in: self)...:
            return endIndex
        default:
            return index(startIndex, offsetBy: original)
        }
    }
    
    // MARK: 8.13、隐藏手机号中间的几位
    /// 隐藏手机号中间的几位
    /// - Parameter combine: 隐藏的字符串(替换的类型)
    /// - Returns: 返回隐藏的手机号
    public func hidePhone(combine: String = "****") -> String {
        if self.count >= 11 {
            let pre = self.sub(start: 0, length: 3)
            let post = self.sub(start: 7, length: 4)
            return pre + combine + post
        } else {
            return self
        }
    }
    
    // MARK:- private 方法
    // MARK: 是否是闰年
    /// 是否是闰年
    /// - Parameter year: 年份
    /// - Returns: 返回是否是闰年
    private func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }
}

extension String {
    //MARK: 将字符串分组
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count {
                result += separator
            }
        }
        return result
    }
    /**
     使用：
     var cardNumber = "1234567890123456"
     cardNumber.insert(separator: " ", every: 4)
     print(cardNumber)
     */
}

// MARK:- 三、字符串的转换
public extension String {
    
    // MARK: 3.1、字符串 转 CGFloat
    /// 字符串 转 Float
    /// - Returns: CGFloat
    func toCGFloat() -> CGFloat? {
        if let doubleValue = Double(self) {
            return CGFloat(doubleValue)
        }
        return nil
    }
    
    // MARK: 3.2、字符串转 bool
    /// 字符串转 bool
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    
    // MARK: 3.3、字符串转 Int
    /// 字符串转 Int
    /// - Returns: Int
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    // MARK: 3.4、字符串转 Double
    /// 字符串转 Double
    /// - Returns: Double
    func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    // MARK: 3.5、字符串转 Float
    /// 字符串转 Float
    /// - Returns: Float
    func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    // MARK: 3.6、字符串转 Bool
    /// 字符串转 Bool
    /// - Returns: Bool
    func toBool() -> Bool? {
        let trimmedString = lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    // MARK: 3.7、字符串转 NSString
    /// 字符串转 NSString
    var toNSString: NSString {
        return self as NSString
    }
}

// MARK:- 四、字符串UI的处理
extension String {
    
    // MARK: 4.1、对字符串(多行)指定出字体大小和最大的 Size，获取 (Size)
    /// 对字符串(多行)指定出字体大小和最大的 Size，获取展示的 Size
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串的最大宽和高
    /// - Returns: 按照 font 和 Size 的字符的Size
    public func rectSize(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        /**
         usesLineFragmentOrigin: 整个文本将以每行组成的矩形为单位计算整个文本的尺寸
         usesFontLeading:
         usesDeviceMetrics:
         @available(iOS 6.0, *)
         truncatesLastVisibleLine:
         */
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
    
    // MARK: 4.2、对字符串(多行)指定字体及Size，获取 (高度)
    /// 对字符串指定字体及Size，获取 (高度)
    /// - Parameters:
    ///   - font: 字体的大小
    ///   - size: 字体的size
    /// - Returns: 返回对应字符串的高度
    public func rectHeight(font: UIFont, size: CGSize) -> CGFloat {
        return rectSize(font: font, size: size).height
    }
    
    // MARK: 4.3、对字符串(多行)指定字体及Size，获取 (宽度)
    /// 对字符串指定字体及Size，获取 (宽度)
    /// - Parameters:
    ///   - font: 字体的大小
    ///   - size: 字体的size
    /// - Returns: 返回对应字符串的宽度
    public func rectWidth(font: UIFont, size: CGSize) -> CGFloat {
        return rectSize(font: font, size: size).width
    }
    
    // MARK: 4.4、对字符串(单行)指定字体，获取 (Size)
    /// 对字符串(单行)指定字体，获取 (Size)
    /// - Parameter font: 字体的大小
    /// - Returns: 返回单行字符串的 size
    public func singleLineSize(font: UIFont) -> CGSize {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrs as [NSAttributedString.Key: Any])
    }
    
    // MARK: 4.5、对字符串(单行)指定字体，获取 (width)
    /// 对字符串(单行)指定字体，获取 (width)
    /// - Parameter font: 字体的大小
    /// - Returns: 返回单行字符串的 width
    public func singleLineWidth(font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrs as [NSAttributedString.Key: Any]).width
    }
    
    // MARK: 4.6、对字符串(单行)指定字体，获取 (Height)
    /// 对字符串(单行)指定字体，获取 (height)
    /// - Parameter font: 字体的大小
    /// - Returns: 返回单行字符串的 height
    public func singleLineHeight(font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrs as [NSAttributedString.Key: Any]).height
    }
    
    // MARK: 4.7、字符串通过 label 根据高度&字体 —> Size
    /// 字符串通过 label 根据高度&字体 ——> Size
    /// - Parameters:
    ///   - height: 字符串最大的高度
    ///   - font: 字体大小
    /// - Returns: 返回Size
    public func sizeAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont) -> CGSize {
        if self.isBlank {return CGSize(width: 0, height: 0)}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect)
        label.font = font
        label.text = self
        label.numberOfLines = 0
        return label.sizeThatFits(rect.size)
    }
    
    // MARK: 4.8、字符串通过 label 根据高度&字体 —> Width
    /// 字符串通过 label 根据高度&字体 ——> Width
    /// - Parameters:
    ///   - height: 字符串最大高度
    ///   - font: 字体大小
    /// - Returns: 返回宽度大小
    public func widthAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect)
        label.font = font
        label.text = self
        label.numberOfLines = 0
        return label.sizeThatFits(rect.size).width
    }
    
    // MARK: 4.9、字符串通过 label 根据宽度&字体 —> height
    /// 字符串通过 label 根据宽度&字体 ——> height
    /// - Parameters:
    ///   - width: 字符串最大宽度
    ///   - font: 字体大小
    /// - Returns: 返回高度大小
    public func heightAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect)
        label.font = font
        label.text = self
        label.numberOfLines = 0
        return label.sizeThatFits(rect.size).height
    }
    
    // MARK: 4.10、字符串根据宽度 & 字体 & 行间距 —> Size
    /// 字符串根据宽度 & 字体 & 行间距 ——> Size
    /// - Parameters:
    ///   - width: 字符串最大的宽度
    ///   - heiht: 字符串最大的高度
    ///   - font: 字体的大小
    ///   - lineSpacing: 行间距
    /// - Returns: 返回对应的size
    public func sizeAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont, lineSpacing: CGFloat) -> CGSize {
        if self.isBlank {return CGSize(width: 0, height: 0)}
        let rect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let label = UILabel(frame: rect)
        label.font = font
        label.text = self
        label.numberOfLines = 0
        let attrStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        label.attributedText = attrStr
        return label.sizeThatFits(rect.size)
    }
    
    // MARK: 4.11、字符串根据宽度 & 字体 & 行间距 —> width
    /// 字符串根据宽度 & 字体 & 行间距 ——> width
    /// - Parameters:
    ///   - width: 字符串最大的宽度
    ///   - heiht: 字符串最大的高度
    ///   - font: 字体的大小
    ///   - lineSpacing: 行间距
    /// - Returns: 返回对应的 width
    public func widthAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont, lineSpacing: CGFloat) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect)
        label.font = font
        label.text = self
        label.numberOfLines = 0
        let attrStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        label.attributedText = attrStr
        return label.sizeThatFits(rect.size).width
    }
    
    // MARK: 4.12、字符串根据宽度 & 字体 & 行间距 —> height
    /// 字符串根据宽度 & 字体 & 行间距 ——> height
    /// - Parameters:
    ///   - width: 字符串最大的宽度
    ///   - heiht: 字符串最大的高度
    ///   - font: 字体的大小
    ///   - lineSpacing: 行间距
    /// - Returns: 返回对应的 height
    public func heightAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont, lineSpacing: CGFloat) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect)
        label.font = font
        label.text = self
        label.numberOfLines = 0
        let attrStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        label.attributedText = attrStr
        return label.sizeThatFits(rect.size).height
    }
}


// MARK:- 九、字符串截取的操作
extension String {
    
    // MARK: 9.1、截取字符串从开始到 index
    /// 截取字符串从开始到 index
    /// - Parameter index: 截取到的位置
    /// - Returns: 截取后的字符串
    public func sub(to index: Int) -> String {
        let end_Index = validIndex(original: index)
        return String(self[startIndex ..< end_Index])
    }
    
    // MARK: 9.2、截取字符串从index到结束
    /// 截取字符串从index到结束
    /// - Parameter index: 截取结束的位置
    /// - Returns: 截取后的字符串
    public func sub(from index: Int) -> String {
        let start_index = validIndex(original: index)
        return String(self[start_index ..< endIndex])
    }
    
    // MARK: 9.3、获取指定位置和长度的字符串
    /// 获取指定位置和大小的字符串
    /// - Parameters:
    ///   - start: 开始位置
    ///   - length: 长度
    /// - Returns: 截取后的字符串
    public func sub(start: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 {
            len = count - start
        }
        let st = index(startIndex, offsetBy: start)
        let en = index(st, offsetBy: len)
        let range = st ..< en
        return String(self[range]) // .substring(with:range)
    }
    
    // MARK: 9.4、切割字符串(区间范围 前闭后开)
    /**
     https://blog.csdn.net/wang631106979/article/details/54098910
     CountableClosedRange：可数的闭区间，如 0...2
     CountableRange：可数的开区间，如 0..<2
     ClosedRange：不可数的闭区间，如 0.1...2.1
     Range：不可数的开居间，如 0.1..<2.1
     */
    /// 切割字符串(区间范围 前闭后开)
    /// - Parameter range: 范围
    /// - Returns: 切割后的字符串
    public func slice(_ range: CountableRange<Int>) -> String { // 如 sliceString(2..<6)
        /**
         upperBound（上界）
         lowerBound（下界）
         */
        let startIndex = validIndex(original: range.lowerBound)
        let endIndex = validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }
    
    // MARK: 9.5、用整数返回子字符串开始的位置
    /// 用整数返回子字符串开始的位置
    /// - Parameter sub: 字符串
    /// - Returns: 返回字符串的位置
    public func position(of sub: String) -> Int {
        if sub.isEmpty {
            return 0
        }
        var pos = -1
        if let range = self.range(of: sub) {
            if !range.isEmpty {
                pos = distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
    /// 富文本设置 字体大小 行间距 字间距
    /// - Parameters:
    ///   - font: 字体大小
    ///   - textColor: 字体颜色
    ///   - lineSpaceing: 行间距
    ///   - wordSpaceing: 字间距
    /// - Returns:
    func attributedString(font: UIFont, textColor: UIColor, lineSpaceing: CGFloat, wordSpaceing: CGFloat) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpaceing
        let attributes = [
            NSAttributedString.Key.font             : font,
            NSAttributedString.Key.foregroundColor  : textColor,
            NSAttributedString.Key.paragraphStyle   : style,
            NSAttributedString.Key.kern             : wordSpaceing]
            
            as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        
        // 设置某一范围样式
        // attrStr.addAttribute(<#T##name: NSAttributedString.Key##NSAttributedString.Key#>, value: <#T##Any#>, range: <#T##NSRange#>)
        return attrStr
    }
    
    func toDictionary() -> [String : Any] {
        
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                                                       options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
        
    }
}

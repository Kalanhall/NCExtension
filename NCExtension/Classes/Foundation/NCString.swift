//
//  String.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/21.
//

import Foundation
import UIKit

// MARK: - 加密 / 转义

public extension Namespace where T == String {
    
    /// String encoded in base64
    ///
    ///        "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = base.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// String decoded from base64
    ///
    ///        "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: base) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    
    /// URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    /// Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return base.removingPercentEncoding ?? base
    }
    
    /// Array of characters of a string.
    var charactersArray: [Character] {
        return Array(base)
    }

}

// MARK: - 字符串校验
public extension Namespace where T == String {

    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in base.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF,      // Misc Symbols and Pictographs
            0x1F680...0x1F6FF,      // Transport and Map
            0x1F1E6...0x1F1FF,      // Regional country flags
            0x2600...0x26FF,        // Misc symbols
            0x2700...0x27BF,        // Dingbats
            0xE0020...0xE007F,      // Tags
            0xFE00...0xFE0F,        // Variation Selectors
            0x1F900...0x1F9FF,      // Supplemental Symbols and Pictographs
            127000...127600,        // Various asian characters
            65024...65039,          // Variation selector
            9100...9300,            // Misc items
            8400...8447:            // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 有效数字校验
    ///
    /// Note:
    /// In North America, "." is the decimal separator,
    /// while in many parts of Europe "," is used,
    ///
    ///     "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///     "abc".isNumeric -> false
    ///
    var isNumeric: Bool {
        let scanner = Scanner(string: base)
        scanner.locale = NSLocale.current
        #if os(Linux)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
    }
    
    /// 纯数字校验
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: base))
    }
    
    /// 纯数字校验
    func digits() -> Bool {
        let number = "^[0-9]*$"
        return matchsForRegx(number)
    }
    
    /// 是否为1开头11位的手机号不带+86等国家编码
    func isValidPhoneNumber() -> Bool {
        let px = "^1[0-9]{10}$"
        return matchsForRegx(px)
    }

    /// 邮箱校验
    func isEmail() -> Bool {
        let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return matchsForRegx(email)
    }
    
    /// 字母校验
    func isLetter() -> Bool {
        let letter = "[a-zA-Z]*"
        return matchsForRegx(letter)
    }
    
    ///  车牌号复杂校验
    ///  包含新能源(大车小车)，非新能源
    func isValidLicenseNumber() -> Bool {
        let license = "^([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[a-zA-Z](([DF]((?![IO])[a-zA-Z0-9](?![IO]))[0-9]{4})|([0-9]{5}[DF]))|[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1})$"
        return matchsForRegx(license)
    }
    
    /// 车牌号简单校验， 只验证整体大致规则， 包含字母数字及汉字+ 长度校验
    func isValidSimpleLicenseNumber() -> Bool {
        let license = "^([A-Z0-9\\u4e00-\\u9fa5]){7,8}$"
        return matchsForRegx(license)
    }
    
    /// 正则表达匹配
    private func matchsForRegx(_ regx: String) -> Bool {
        let regxpd = NSPredicate(format: "SELF MATCHES %@",regx)
        return regxpd.evaluate(with: base)
    }
}

// MARK: - 字符串转换
public extension Namespace where T == String {
    
    /// 转成通知类型
    var notification: Notification.Name {
        return Notification.Name(self.base)
    }
    
    /// 字符串转日期
    func date(from format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        let lowercased = base.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return formatter.date(from: lowercased)
    }

    /// 复制到剪切板
    ///
    ///        "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self.base
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(base, forType: .string)
        #endif
    }
    
    /// 是否包含字符串，区分大小写
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.range(of: string, options: .caseInsensitive) != nil
        }
        return base.range(of: string) != nil
    }
    
    /// 包含的字符串个数，区分大小写
    ///
    ///        "Hello World!".count(of: "o") -> 2
    ///        "Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return base.lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return base.components(separatedBy: string).count - 1
    }
    
    /// 判断字符串前缀，区分大小写
    ///
    ///        "hello World".starts(with: "h") -> true
    ///        "hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.lowercased().hasPrefix(prefix.lowercased())
        }
        return base.hasPrefix(prefix)
    }
    
    /// 随机指定长度字符串
    ///
    ///        String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }
    
    /// 字符串反转
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = base.reversed()
        base = String(chars)
        return base
    }
    
    /// 截取字符串，下标，长度
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < base.count  else { return nil }
        guard index.advanced(by: length) <= base.count else {
            return base[safe: index..<base.count]
        }
        guard length > 0 else { return "" }
        return base[safe: index..<index.advanced(by: length)]
    }
    
    /// 截取指定下标及后面的所有字符串
    ///
    ///        var str = "Hello World"
    ///        str.slice(at: 6)
    ///        print(str) // prints "World"
    ///
    /// - Parameter index: string index the slicing should start from.
    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < base.count else { return base }
        if let str = base[safe: index..<base.count] {
            base = str
        }
        return base
    }
    
    /// 最长显示指定长度字符串，后面补...
    ///
    ///        "This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 1..<base.count ~= length else { return base }
        return base[base.startIndex..<base.index(base.startIndex, offsetBy: length)] + (trailing ?? "")
    }
}

// MARK: - 阿里、腾讯图片链接拼接

public extension String {
    /// 支持参数拼接的图片云平台
    enum OssType {
        /// 阿里，腾讯
        case alicloud, txcloud, unsupport
    }
}

public extension Namespace where T == String {
    
    /// 根据当前String拼接对应平台参数
    func ossForResize(with size: CGSize = CGSize(width: 1080, height: 1920),
                      mode: UIView.ContentMode = .scaleToFill,
                      scale: CGFloat = UIScreen.main.scale) -> String {
        let type = matchOssType()
        switch type {
        case .alicloud:
            return configurationAliOss(size, mode, scale)
        case .txcloud:
            return configurationTXOss(size, mode, scale)
        default:
            return base
        }
    }
    
    func matchOssType() -> String.OssType {
        var rg = base.range(of: "aliyuncs.com")
        if let `rg` = rg, !`rg`.isEmpty {
            return .alicloud
        }
        
        rg = base.range(of: "myqcloud.com")
        if let `rg` = rg, !`rg`.isEmpty {
            return .txcloud
        }
        
        return .unsupport
    }
    
    /// 阿里:  https://help.aliyun.com/document_detail/44688.html?spm=a2c4g.11186623.4.1.1e211729pKbgfI
    func configurationAliOss(_ size: CGSize = CGSize(width: 1080, height: 1920),
                                 _ mode: UIView.ContentMode = .scaleToFill,
                                 _ scale: CGFloat = UIScreen.main.scale) -> String {
        // 防止url中含有?参数，有的话就不拼接了
        if let rg = base.range(of: "?"), !rg.isEmpty {
            return base
        }
       
        let h = (Int)(scale * size.height)
        let w = (Int)(scale * size.width)
        
        // 没有尺寸默认返回
        if h == 0 || w == 0 {
            return base + "?x-oss-process=image/resize,m_fill,h_1920,w_1080"
        }
        
        // 根据视图尺寸返回
        switch mode {
        case .scaleToFill:
            return base + "?x-oss-process=image/resize,m_fixed,h_\(h),w_\(w)"
        case .scaleAspectFit:
            return base + "?x-oss-process=image/resize,m_pad,h_\(h),w_\(w)"
        case .scaleAspectFill:
            return base + "?x-oss-process=image/resize,m_fill,h_\(h),w_\(w)"
        default:
            return base + "?x-oss-process=image/resize,m_fill,h_1920,w_1080"
        }
    }
    
    /// 腾讯:  http://www.5imoban.net/jiaocheng/fuwuqi/202006103867.html
    func configurationTXOss(_ size: CGSize = CGSize(width: 1080, height: 1920),
                                _ mode: UIView.ContentMode = .scaleToFill,
                                _ scale: CGFloat = UIScreen.main.scale) -> String {
        // 防止url中含有?参数，有的话就不拼接了
        if let rg = base.range(of: "?"), !rg.isEmpty {
            return base
        }
       
        let h = (Int)(scale * size.height)
        let w = (Int)(scale * size.width)
        
        // 没有尺寸默认返回
        if h == 0 || w == 0 {
            return base + "?imageView2/3/w/1080/h/1920"
        }
        
        // 根据视图尺寸返回
        switch mode {
        case .scaleToFill:
            return base + "?imageView2/3/w/\(w)/h/\(h)"
        case .scaleAspectFit:
            return base + "?imageView2/2/w/\(w)/h/\(h)"
        case .scaleAspectFill:
            return base + "?imageView2/1/w/\(w)/h/\(h)"
        default:
            return base + "?imageView2/3/w/1080/h/1920"
        }
    }
    
}

public extension String {
    /// Safely subscript string with index.
    ///
    ///        "Hello World!"[safe: 3] -> "l"
    ///        "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: index.
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }

    /// Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex...upperIndex])
    }
}

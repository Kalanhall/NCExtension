//
//  Font.swift
//  NPSwift
//
//  Created by Kalan on 2021/6/28.
//

import UIKit

public extension Namespace where T == UIFont {
    
    static func regular(size fontSize: CGFloat) -> UIFont {
        return UIFont(regular: fontSize)!
    }
    
    static func medium(size fontSize: CGFloat) -> UIFont {
        return UIFont(medium: fontSize)!
    }
    
    static func light(size fontSize: CGFloat) -> UIFont {
        return UIFont(light: fontSize)!
    }
    
    static func bold(size fontSize: CGFloat) -> UIFont {
        return UIFont(bold: fontSize)!
    }
    
    static func semibold(size fontSize: CGFloat) -> UIFont {
        return UIFont(semibold: fontSize)!
    }
}

public extension UIFont {
    
    convenience init?(regular size: CGFloat) {
        self.init(name: "PingFang-SC-Regular", size: size)
    }
    
    convenience init?(medium size: CGFloat) {
        self.init(name: "PingFang-SC-Medium", size: size)
    }
    
    convenience init?(light size: CGFloat) {
        self.init(name: "PingFang-SC-Light", size: size)
    }
    
    convenience init?(bold size: CGFloat) {
        self.init(name: "PingFang-SC-Bold", size: size)
    }
    
    convenience init?(semibold size: CGFloat) {
        self.init(name: "PingFang-SC-Semibold", size: size)
    }
    
}

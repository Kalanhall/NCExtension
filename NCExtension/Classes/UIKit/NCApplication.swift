//
//  Application.swift
//  NPSwift
//
//  Created by company on 2021/7/8.
//

import UIKit

public extension Namespace where T == UIApplication {
    
    // MARK: - 沙盒路径
    
    static func documentsURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    static func documentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    static func cachesURL() -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    
    static func cachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    
    static func librarysURL() -> URL? {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    
    static func librarysPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
    }
    
    // MARK: - 应用信息
    
    static func name() -> String {
        guard let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
            return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        }
        return name
    }
    
    static func bundleId() -> String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }
    
    /// Version版本号
    static func version() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// Build版本号
    static func buildVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    // MARK: - 顶层控制器
    /// 获取显示控制器
    /// - parameter root: 窗口根控制器
    static func visibleController(in root: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return visibleController(in: nav.visibleViewController)
        }
        if let tab = root as? UITabBarController {
            return visibleController(in: tab.selectedViewController)
        }
        if let presented = root?.presentedViewController {
            return visibleController(in: presented)
        }
        return root
    }
}

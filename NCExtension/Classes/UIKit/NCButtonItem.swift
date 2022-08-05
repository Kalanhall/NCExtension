//
//  ButtonItem.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/21.
//

import Foundation

public extension Namespace where T == UIBarButtonItem {
    
    /// 快捷监听按钮事件，仅支持一个对象只订阅一次
    /// - parameter subscribe: 订阅事件回调
    @discardableResult
    func subscribe(_ subscribe: ((UIBarButtonItem) -> Void)?) -> UIBarButtonItem {
        let button = base
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        objc_setAssociatedObject(button, key, subscribe, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        button.target = button
        button.action = #selector(UIBarButtonItem.touch(_:))
        return button
    }
    
}

extension UIBarButtonItem {
    
    @objc func touch(_ sender: UIBarButtonItem) {
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        let closure = objc_getAssociatedObject(self, key) as? (UIBarButtonItem) -> Void
        closure?(sender)
    }
    
}

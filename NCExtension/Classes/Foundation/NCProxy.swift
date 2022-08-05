//
//  NCProxy.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/22.
//

import Foundation
import CoreMedia
import UIKit

public extension Namespace where T: NSObject {
    
    // MARK: - NSNotification
    
    /// 观察者自动销毁的通知监听
    /// - Parameter name: 通知名称
    /// - Parameter object: 传值
    /// - Parameter using: 回调
    func observe(for name: NSNotification.Name, object: Any?, using: @escaping (Notification) -> Void) {
        let proxy = NCProxy()
        proxy.using = using
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: name.hashValue)
        objc_setAssociatedObject(self.base, key, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        NotificationCenter.default.addObserver(proxy, selector: #selector(NCProxy.notification(_:)), name: name, object: object)
    }
    
    // MARK: - KVO
    
    /// 观察者自动销毁的KVO
    ///
    ///     let person = Person()
    ///     person.nc.addObserver(self, #keyPath(Person.name), options: [.new]) { obj, change in
    ///         print("1 \(obj) => \(change?[.newKey])")
    ///     }
    ///     person.name = "Test" // @objc dynamic 观察属性必须声明
    ///
    /// - Parameter observed: 被观察者
    /// - Parameter keyPath: 被观察者属性路径，推荐 #keyPath(Person.name)
    /// - Parameter options: 监听值类型，默认 new
    /// - Parameter changeHandler: 变更回调
    func observe(_ observed: NSObject, for keyPath: String, options: NSKeyValueObservingOptions = [.new], changeHandler: @escaping ((Any?, [NSKeyValueChangeKey : Any]?) -> Void)) {
        let proxy = NCProxy()
        proxy.observed = observed // 记录被观察者，等释放后移除对应的keypath
        proxy.keyPath = keyPath
        proxy.changeHandler = changeHandler
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: keyPath.hashValue)
        objc_setAssociatedObject(self.base, key, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        observed.addObserver(proxy, forKeyPath: keyPath, options: options, context: nil)
    }
    
    // MARK: - Timer
    
    @discardableResult
    func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let proxy = NCProxy()
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
        RunLoop.current.add(timer, forMode: .common)
        proxy.timer = timer
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "ns.scheduledTimer".hashValue)
        objc_setAssociatedObject(self.base, key, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return timer
    }
}

class NCProxy: NSObject {
    // 被观察者
    var observed: NSObject?
    var keyPath: String?
    var changeHandler: ((Any?, [NSKeyValueChangeKey : Any]?) -> Void)?
    // 通知回调
    var using: ((Notification) -> Void)?
    // 定时器
    var timer: Timer?
    
    @objc func notification(_ n: Notification) {
        using?(n)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        changeHandler?(object, change)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        
        if keyPath != nil {
            // 移除KVO
            self.observed?.removeObserver(self, forKeyPath: keyPath!)
        }
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

//
//  NCPeachability.swift
//  NPSwift
//
//  Created by beantechs on 2021/12/24.
//  实时网络状态监控

import Foundation
import Network

extension NCPeachability: NamespacesWrappable {}
public extension Namespace where T == NCPeachability {

    /// 获取一次实时网络状态
    ///
    ///     NCPeachability.nc.once { status in
    ///         print(status)
    ///     }
    /// changed call back on main queue.
    ///
    static func once(changed: @escaping ((NCPeachabilityStatus) -> Void)) {
        NCPeachability.shared.reachability(changed: changed)
    }
    
    /// 获取网络状态，请初始化subscribe网路监听，否则默认为 unknow
    static var status: NCPeachabilityStatus {
        return NCPeachability.shared.status
    }
    
    /// 持续监听实时网络状态（内存常驻）
    ///
    /// 方式一：block
    ///
    ///     NCPeachability.nc.subscribe { reachability in
    ///         print("status = \(reachability.status)")
    ///     }
    ///
    /// 方式二：通知
    ///
    ///     self.ns.observe(for: .nc.reachabilityDidChange, object: nil) { n in
    ///         guard let reachability = n.object as? NCPeachability else { return }
    ///         print("status = \(reachability.status)")
    ///     }
    /// - Parameters: timeInterval  监控频率，默认 1s
    ///
    /// changed call back on main queue.
    ///
    static func subscribe(timeInterval: TimeInterval = 1, changed: @escaping ((NCPeachability) -> Void)) {
        let reachability = NCPeachability.shared
        reachability.changed = changed
        reachability.startMonitor()
    }
    
    /// 取消网络订阅
    static func cancleSubscribe() {
        let reachability = NCPeachability.shared
        reachability.stopMonitor()
    }
}

public enum NCPeachabilityStatus {
    /// 默认值
    case unknow
    /// 网络不可用
    case offline
    /// 网络可用
    case online
}

public extension Namespace where T == Notification.Name {
    static var reachabilityDidChange: Notification.Name {
        return Notification.Name("namespace.reachabilityChanged")
    }
}

public class NCPeachability {
    
    private static var _shared: NCPeachability?
    static var shared: NCPeachability {
        guard let instance = _shared else {
            _shared = NCPeachability()
            return _shared!
        }
        return instance
    }
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 1
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config)
        return session
    }()
    private var loop: Timer?
    
    /// 启动监听后，可以直接获取网络状态
    public var status: NCPeachabilityStatus = .unknow {
        didSet {
            guard status != oldValue else { return }
            reachabilityChanged()
        }
    }
    
    public var changed: ((NCPeachability) -> Void)?
    
    func startMonitor() {
        self.loop?.invalidate()
        self.loop = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            self?.reachability { [weak self] status in
                self?.status = status
            }
        })
        RunLoop.current.add(self.loop!, forMode: .common)
        self.loop?.fire()
    }
    
    func stopMonitor() {
        self.loop?.invalidate()
        self.loop = nil
        // 销毁单例
        NCPeachability._shared = nil
    }
    
    func reachability(changed: @escaping ((NCPeachabilityStatus) -> Void)) {
        guard let url = URL(string: "https://www.apple.com") else { return }
        self.session.dataTask(with: url) { _, response, _ in
            DispatchQueue.main.async {
                changed(response != nil ? .online : .offline)
            }
        }.resume()
    }
    
    func reachabilityChanged() {
        changed?(self)
        NotificationCenter.default.post(name: .nc.reachabilityDidChange, object: self)
    }
}

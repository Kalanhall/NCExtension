//
//  ExtButton.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/20.
//

import Foundation

public extension Namespace where T: UIButton {
    
    /// 快捷监听按钮事件，仅支持一个对象只订阅一次
    /// - parameter event: 监听事件
    /// - parameter subscribe: 订阅事件回调
    func subscribe(_ event: UIControl.Event, _ subscribe: @escaping (UIButton) -> Void) {
        let button = base
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        objc_setAssociatedObject(button, key, subscribe, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        button.addTarget(button, action: #selector(UIButton.touch(_:)), for: event)
    }
    
    /// 设置按钮图片展示位置
    /// - parameter adjustment: 图片展示的位置
    /// - parameter space: 文字与图片间的距离
    func setAdjustment(_ adjustment: UIButton.ImageAdjustment, space: CGFloat) {
        let button = base
        guard let _ = button.imageView?.image, let text = button.titleLabel?.text else { return }
        // image
        let iw = button.imageView?.bounds.size.width ?? 0
        let ih = button.imageView?.bounds.size.height ?? 0
        // label
        var lw = button.titleLabel?.bounds.size.width ?? 0
        let lh = button.titleLabel?.bounds.size.height ?? 0
        
        let ts = text.size(withAttributes: [.font : button.titleLabel!.font!])
        let fs = CGSize(width: ts.width, height: ts.height)
        if lw < fs.width {
            lw = fs.width
        }
    
        let offset = space / 2.0
        switch adjustment {
        case .top:
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: lh + space, right: -lw)
        button.titleEdgeInsets = UIEdgeInsets(top: ih + space, left: -iw, bottom: 0, right: 0)
        case .left:
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
        case .bottom:
        button.imageEdgeInsets = UIEdgeInsets(top: lh + space, left: 0, bottom: 0, right: -lw)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -iw, bottom: ih + space, right: 0)
        case .right:
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: lw+offset, bottom: 0, right: -lw-offset)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -iw-offset, bottom: 0, right: iw+offset)
        }
    }
}

extension UIButton {
    
    /// 图片展示方位
    public enum ImageAdjustment {
        case top, left, bottom, right
    }
    
    @objc func touch(_ sender: UIButton) {
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        let closure = objc_getAssociatedObject(self, key) as? (UIButton) -> Void
        closure?(sender)
    }
}

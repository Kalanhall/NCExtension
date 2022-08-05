//
//  View.swift
//  NPSwift
//
//  Created by company on 2021/6/28.
//

import UIKit

public extension Namespace where T: UIView {
    
    /// View所在控制器
    func controller() -> UIViewController? {
        var view: UIView? = base
        while (view != nil) {
            let nextResponder = view?.next
            if nextResponder is UIViewController {
                return nextResponder as? UIViewController
            }
            view = view?.superview
        }
        return nil
    }
    
    /// 添加阴影
    func shadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = .zero, radius: CGFloat = 3) {
        let view = base
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
    }
    
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func maskedCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let view = base
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
            view.layer.cornerRadius = radius
        } else {
            view.layoutIfNeeded()
            let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            view.layer.mask = shape
        }
    }
    
    /// 快捷截图1
    func snapshotImage() -> UIImage? {
        let view = base
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    /// 快捷截图2
    func snapshotImage(afterScreenUpdates afterUpdates: Bool) -> UIImage? {
        let view = base
        if !view.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
            return snapshotImage()
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: afterUpdates)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    /// 快捷创建点击事件
    @discardableResult
    func subscribeForTap(_ subscribe: ((UITapGestureRecognizer) -> Void)?) -> Self.T {
        let view = base
        view.isUserInteractionEnabled = true
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        objc_setAssociatedObject(view, key, subscribe, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.gestureAction(_:)))
        view.addGestureRecognizer(tap)
        return view
    }
    
}

extension UIView {
    
    @objc func gestureAction(_ tap: UITapGestureRecognizer) {
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        let closure = objc_getAssociatedObject(self, key) as? (UITapGestureRecognizer) -> Void
        closure?(tap)
    }
}

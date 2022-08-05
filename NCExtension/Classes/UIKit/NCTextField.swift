//
//  TextField.swift
//  NPSwift
//
//  Created by Kalan on 2021/7/8.
//

import UIKit

public extension Namespace where T == UITextField {
    
    /// 清空文本
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }
    
    /// 设置占位文字属性
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderText(_ text: String?, color: UIColor, font: UIFont = UIFont.systemFont(ofSize: 15)) {
        base.placeholder = text
        guard let holder = base.placeholder, !holder.isEmpty else { return }
        base.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color, .font: font])
    }
    
    /// 快捷监听文本变更事件
    /// - parameter event: 监听事件
    /// - parameter subscribe: 订阅事件回调
    func subscribe(_ event: UIControl.Event = .editingChanged, _ subscribe: ((UITextField) -> Void)?) {
        let textfield = base
        let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
        objc_setAssociatedObject(textfield, key, subscribe, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        textfield.addTarget(textfield, action: #selector(textfield.change(_:)), for: event)
    }
    
    /// 设置文本左边距
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: base.frame.height))
        base.leftView = paddingView
        base.leftViewMode = .always
    }

    /// 设置左视图图片
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        base.leftView = imageView
        base.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        base.leftViewMode = .always
    }
    
    /// 设置文本右边距
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingRight(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: base.frame.height))
        base.rightView = paddingView
        base.rightViewMode = .always
    }

    /// 设置右视图图片
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    func addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        base.rightView = imageView
        base.rightView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        base.rightViewMode = .always
    }
    
}

extension UITextField {
    
    @objc func change(_ textField: UITextField) {
        // https://www.jianshu.com/p/e78670013373 解决方法：输入内容时，仅在不是高亮状态下获取输入的文字
        let range = textField.markedTextRange
        if range == nil || range?.isEmpty == true {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "nsp.subscribe".hashValue)
            let closure = objc_getAssociatedObject(self, key) as? (UITextField) -> Void
            closure?(textField)
        }
    }
}

//
//  Namespace.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/20.
//

import Foundation
import UIKit

public protocol Namespace {
    associatedtype T
    var base: T { get set }
    init(_ base: T)
}

public struct NamespaceStuct<T>: Namespace {
    public var base: T
    public init(_ base: T) {
        self.base = base
    }
}

public protocol NamespacesWrappable {
    associatedtype WrappableType
    var nc: WrappableType { get }
    static var nc: WrappableType.Type { get }
}

public extension NamespacesWrappable {
    var nc: NamespaceStuct<Self> {
        return NamespaceStuct(self)
    }
    
    static var nc: NamespaceStuct<Self>.Type {
        return NamespaceStuct.self
    }
}

// MARK: 遵循协议

extension NSObject:             NamespacesWrappable {}

extension Int:                  NamespacesWrappable {}
extension UInt:                 NamespacesWrappable {}
extension Int64:                NamespacesWrappable {}
extension UInt64:               NamespacesWrappable {}
extension Double:               NamespacesWrappable {}
extension Float:                NamespacesWrappable {}
extension Bool:                 NamespacesWrappable {}

extension CGFloat:              NamespacesWrappable {}
extension CGPoint:              NamespacesWrappable {}
extension CGRect:               NamespacesWrappable {}
extension CGSize:               NamespacesWrappable {}
extension CGVector:             NamespacesWrappable {}

extension UIEdgeInsets:         NamespacesWrappable {}
extension UIOffset:             NamespacesWrappable {}
extension UIRectEdge:           NamespacesWrappable {}

extension Set:                  NamespacesWrappable {}
extension String:               NamespacesWrappable {}
extension Array:                NamespacesWrappable {}
extension Dictionary:           NamespacesWrappable {}

extension URL:                  NamespacesWrappable {}
extension Data:                 NamespacesWrappable {}
extension Date:                 NamespacesWrappable {}
extension Notification.Name:    NamespacesWrappable {}

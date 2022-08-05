//
//  Then.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/20.
//

import Foundation

extension Namespace where Self: Any {

    /// Makes it available to set properties with closures just after initializing and copying the base types.
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    @discardableResult
    @inlinable
    public func with(_ block: (inout Self.T) throws -> Void) rethrows -> Self.T {
        var copy = self.base
        try block(&copy)
        return copy
    }

    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    @inlinable
    public func `do`(_ block: (Self.T) throws -> Void) rethrows {
        try block(self.base)
    }
    
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    @discardableResult
    @inlinable
    public func then(_ block: (Self.T) throws -> Void) rethrows -> Self.T {
        try block(self.base)
        return self.base
    }

}

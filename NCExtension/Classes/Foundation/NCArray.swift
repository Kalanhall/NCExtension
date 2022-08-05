//
//  Array.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/22.
//

import Foundation

public extension Namespace where T == Array<Any> {
    
    /// 获取对象在数组中的下标，Index / NSNotFound
    func index(of object: Any) -> Array.Index {
        return base.index(of: object)
    }
    
    /// 获取下标对应的对象
    func safeObject(at index: Array.Index) -> Array<Any>.Element? {
        return base.safeObject(at: index)
    }
}

public extension Array {
    
    /// 按指定下标读取或赋值
    ///
    ///        var array =  ["1", "2", "3"]
    ///        array[safe: 1] == "2"
    ///        array[safe: 2] = "4"
    ///        array[safe: 2] == "4"
    ///        array[safe: 3] == nil
    ///
    subscript(safe index: Index) -> Element? {
        get {
            /// 越界处理
            return indices.contains(index) ? self[index] : nil
        }
        set {
            if indices.contains(index) {
                if let value = newValue {
                    self[index] = value
                } else {
                    self[index] = Optional<Any>(nilLiteral: ()) as! Element
                }
            }
        }
    }
    
    /// 获取对象在数组中的下标，Index / NSNotFound
    func index(of object: Any) -> Index {
        return (self as NSArray).index(of: object)
    }
    
    /// 获取下标对应的对象
    func safeObject(at index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /// 头部插入元素
    ///
    ///        var array = [2, 3, 4, 5]
    ///        array.prepend(1) -> [1, 2, 3, 4, 5]
    ///
    /// - Parameter newElement: element to insert.
    mutating func preapend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// 元素位置交换
    ///
    ///        var array = ["h", "e", "l", "l", "o"]
    ///        array.safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
}

public extension Array where Element: Equatable {
    
    /// 移除指定元素
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"].removeAll("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: item to remove.
    /// - Returns: self after removing all instances of item.
    @discardableResult
    mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }
    
    /// 移除集合内所有元素
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
    ///        ["h", "e", "l", "l", "o"].removeAll(["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter items: items to remove.
    /// - Returns: self after removing all instances of all items in given array.
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }
    
    /// 元素去重
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].withoutDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    func removeDuplicates() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    /// 系统对象去重
    ///
    /// - Parameter path: Key path to compare, the value must be Hashable.
    /// - Returns: an array of unique elements.
    func withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
    
    /// 自定义对象去重
    ///
    /// - Parameter path: Key path to compare, the value must be Equatable.
    /// - Returns: an array of unique elements.
    func withoutDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, element) in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }
}

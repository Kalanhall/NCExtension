//
//  Number.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/22.
//

import Foundation

public extension Namespace where T == Double {
    
    /// 转成保留指定位数的小数字符串，默认2位小数
    func string(decimals: Int = 2) -> String {
        return String(format: "%.\(decimals)f", base)
    }
    
    /// 角度转弧度
    var degreesToRadians: Double {
        return .pi * base / 180.0
    }
    
    /// 弧度转角度
    var radiansToDegrees: Double {
        return base * 180 / Double.pi
    }
}

public extension Namespace where T == TimeInterval {
    
    /// 日历
    private var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier) // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    }
    
    func date() -> Date? {
        return Date(timeIntervalSince1970: base)
    }
    
    /// 仅限比较是否是同一天/月/年等，默认按天比较
    func compare(_ time: TimeInterval, component: Calendar.Component = .day) -> Bool {
        guard let first = date(), let second = time.nc.date() else {
            return false
        }
        let comp1 = calendar.dateComponents([.year,.month,.day], from: first)
        let comp2 = calendar.dateComponents([.year,.month,.day], from: second)
        switch component {
        case .year:
            return comp1.year == comp2.year
        case .month:
            return comp1.year == comp2.year && comp1.month == comp2.month
        case .day:
            return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day
        default:
            return false
        }
    }
}

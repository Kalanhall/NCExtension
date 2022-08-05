//
//  Date.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/22.
//

import Foundation

public extension Namespace where T == Date {
    
    /// 日历
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier) // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    }
    
    /// 昨天
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: base) ?? Date()
    }

    /// 明天
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: base) ?? Date()
    }
    
    var year: Int {
        return calendar.component(.year, from: base)
    }
    
    var month: Int {
        return calendar.component(.month, from: base)
    }
    
    var day: Int {
        return calendar.component(.day, from: base)
    }
    
    var houre: Int {
        return calendar.component(.hour, from: base)
    }
    
    var minute: Int {
        return calendar.component(.minute, from: base)
    }
    
    var second: Int {
        return calendar.component(.second, from: base)
    }
    
    /// 年内第几周
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: base)
    }

    /// 月内第几周
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: base)
    }
    
    ///  未来时间
    var isInFuture: Bool {
        return base > Date()
    }

    ///  过去时间
    var isInPast: Bool {
        return base < Date()
    }

    var isInToday: Bool {
        return calendar.isDateInToday(base)
    }

    var isInYesterday: Bool {
        return calendar.isDateInYesterday(base)
    }

    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(base)
    }

    var isInWeekend: Bool {
        return calendar.isDateInWeekend(base)
    }

    var isWorkday: Bool {
        return !calendar.isDateInWeekend(base)
    }

    var isInCurrentWeek: Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var isInCurrentMonth: Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .month)
    }

    var isInCurrentYear: Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .year)
    }

    // MARK: - 转换
    
    /// 转字符串
    func string(withFormat format: String = "yyyy-MM-dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: base)
    }
    
    ///  两个日期之间
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(base).rawValue * base.compare(endDate).rawValue >= 0
        }
        return startDate.compare(base).rawValue * base.compare(endDate).rawValue > 0
    }
    
    /// 仅限比较是否是同一天/月/年等，默认按天比较
    func compare(_ date: Date, component: Calendar.Component = .day) -> Bool {
        let comp1 = calendar.dateComponents([.year,.month,.day], from: base)
        let comp2 = calendar.dateComponents([.year,.month,.day], from: date)
        switch component {
        case .year:
            return comp1.year == comp2.year
        case .month:
            return comp1.year == comp2.year && comp1.month == comp2.month
        case .day:
            return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day
        default:
            return base == date
        }
    }

}

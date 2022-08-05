//
//  RefreshControl.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/22.
//

import Foundation

// MARK: - UIRefreshControl
public extension Namespace where T == UIRefreshControl {
    
    /// SwifterSwift: Programatically begin refresh control inside of UITableView.
    ///
    /// - Parameters:
    ///   - tableView: UITableView instance, inside which the refresh control is contained.
    ///   - animated: Boolean, indicates that is the content offset changing should be animated or not.
    ///   - sendAction: Boolean, indicates that should it fire sendActions method for valueChanged UIControlEvents
    func beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        // https://stackoverflow.com/questions/14718850/14719658#14719658
        assert(base.superview == tableView, "Refresh control does not belong to the receiving table view")

        base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -base.frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            base.sendActions(for: .valueChanged)
        }
    }
    
}

// MARK: - UIScrollView
public extension Namespace where T: UIScrollView {
    
    /// 滚动视图截图
    ///
    ///    AnySubclassOfUIScroolView().snapshot
    ///    UITableView().snapshot
    ///
    /// - Returns: Snapshot as UIimage for rendered ScrollView
    var snapshot: UIImage? {
        // Original Source: https://gist.github.com/thestoics/1204051
        UIGraphicsBeginImageContextWithOptions(base.contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = base.frame
        base.frame = CGRect(origin: base.frame.origin, size: base.contentSize)
        base.layer.render(in: context)
        base.frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 滚动至顶部
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        if base.isKind(of: UITextView.self) {
            let textV = base as! UITextView
            let range = NSMakeRange(0, 1)
            textV.scrollRangeToVisible(range)
        } else {
            base.setContentOffset(CGPoint.zero, animated: animated)
        }
    }
    
    /// 滚动至底部
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToBottom(animated: Bool = true) {
        if base.isKind(of: UITextView.self) {
            let textV = base as! UITextView
            let range = NSMakeRange((textV.text as NSString).length - 1, 1)
            textV.scrollRangeToVisible(range)
        } else {
            let bottomOffset = CGPoint(x: 0, y: base.contentSize.height - base.bounds.size.height)
            base.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
}

// MARK: - UITextView
public extension Namespace where T: UITextView {
    /// 清空文本
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }
}

// MARK: - UITableView
public extension Namespace where T: UITableView {
    
    /// 注册Cell
    ///
    /// - Parameter name: UITableViewCell type
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        base.register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    /// 数据源个数
    ///
    /// - Returns: The count of all rows in the tableView.
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < base.numberOfSections {
            rowCount += base.numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }

    /// 所在组的最后一行的IndexPath
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard base.numberOfSections > 0, section >= 0 else { return nil }
        guard base.numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: base.numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// 带回调的刷新
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            base.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 最后一行的IndexPath
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

    /// 最后一组的下标
    var lastSection: Int? {
        return base.numberOfSections > 0 ? base.numberOfSections - 1 : nil
    }
    
}

// MARK: - UICollectionView
public extension Namespace where T: UICollectionView {
    
    /// 注册Cell
    ///
    /// - Parameter name: UITableViewCell type
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        base.register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    /// 数据源个数
    ///
    /// - Returns: The count of all rows in the tableView.
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < base.numberOfSections {
            itemsCount += base.numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }

    /// 所在组的最后一行的IndexPath
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < base.numberOfSections else {
            return nil
        }
        guard base.numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: base.numberOfItems(inSection: section) - 1, section: section)
    }
    
    /// 带回调的刷新
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            base.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 最后一行的IndexPath
    var indexPathForLastItem: IndexPath? {
        return indexPathForLastItem(inSection: lastSection)
    }

    /// 最后一组的下标
    var lastSection: Int {
        return base.numberOfSections > 0 ? base.numberOfSections - 1 : 0
    }
    
}

// MARK: - UIStackView
@available(iOS 9.0, *)
public extension Namespace where T: UIStackView {

    /// 添加视图数组
    ///
    /// - Parameter views: views array.
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            base.addArrangedSubview(view)
        }
    }

    /// 移除所有视图
    func removeArrangedSubviews() {
        for view in base.arrangedSubviews {
            base.removeArrangedSubview(view)
        }
    }

}

public extension UIStackView {
    
    /// 自定义构造方法
    ///
    ///     let stackView = UIStackView(arrangedSubviews: [UIView(), UIView()], axis: .vertical)
    ///
    /// - Parameters:
    ///   - arrangedSubviews: 添加的视图集合
    ///   - axis: 有两个值，可以设置子视图是水平布局还是垂直布局。
    ///   - spacing: 设置子视图间的距离。
    ///   - alignment: 设置子视图的显示位置，UIStackViewAlignmentFill可以让子视图铺满（如果是均匀布局可以使用此值）
    ///   - distribution: UIStackViewDistributionFillEqually可以让子视图的宽或是高相等（如果是均匀布局可以使用此值）。
    convenience init(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill) {

        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
}

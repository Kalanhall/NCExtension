//
//  Image.swift
//  NPSwift
//
//  Created by Kalan on 2019/11/13.
//

import UIKit
import ImageIO

public extension Namespace where T == UIImage {
    
    /// 显示原图
    var original: UIImage {
        return base.withRenderingMode(.alwaysOriginal)
    }
    
    func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        return UIImage(color: color, size: size)
    }
    
    /// 根据16进制值生成对应尺寸图片
    func image(with hex: UInt, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        return UIImage(color: UIColor(hex: hex), size: size)
    }
    
    /// 根据16进制字符串生成对应尺寸图片
    func image(with hexString: String, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        guard let color = UIColor(hexString: hexString) else { return nil }
        return UIImage(color: color, size: size)
    }
    
    /// 返回带圆角图片
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(base.size.width, base.size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(base.size, false, 0)

        let rect = CGRect(origin: .zero, size: base.size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        base.draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片压缩
    /// 转自: https://swift.gg/2019/11/01/image-resizing 技巧 #3
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]

        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }

        return UIImage(cgImage: image)
    }
    
    
}

public extension UIImage {
    
    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { /// 作用域结束后调用
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
}

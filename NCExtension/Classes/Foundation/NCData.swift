//
//  Data.swift
//  NPSwift
//
//  Created by Kalan on 2021/12/22.
//

import Foundation

public enum PictureType {
    case undefined, jpeg, png, gif, tiff, webP, heic, heif
}

public extension Namespace where T == Data {
    /// 判断图片格式
    var pictureType: PictureType {
        var c: UInt8 = UInt8()
        
        guard !base.isEmpty else {
            return .undefined
        }
        
        base.copyBytes(to: &c, count: 1)
        switch c {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        case 0x52:
            if (base as NSData).length >= 12 {
                guard let range = Range<Data.Index>(NSRange(location: 0, length: 12)) else {
                    return .undefined
                }
                let data = base.subdata(in: range)
                guard let string = String(data: data, encoding: .ascii) else {
                    return .undefined
                }
                if string.hasPrefix("RIFF") && string.hasSuffix("WEBP") {
                    return .webP
                }
            }
        case 0x00:
            if (base as NSData).length >= 12 {
                guard let range = Range<Data.Index>(NSRange(location: 4, length: 8)) else {
                    return .undefined
                }
                let data = base.subdata(in: range)
                guard let string = String(data: data, encoding: .ascii) else {
                    return .undefined
                }
                if string == "ftypheic" || string == "ftypheix" || string == "ftyphevc" || string == "ftyphevx" {
                    return .heic
                }
                if string == "ftypmif1" || string == "ftypmsf1" {
                    return .heif
                }
            }
        default:
            return .undefined
        }
        return .undefined
    }
}

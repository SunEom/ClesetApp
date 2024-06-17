//
//  UIImage+Extensions.swift
//  Cleset
//
//  Created by 엄태양 on 6/17/24.
//

import UIKit

extension UIImage {
    public func downscaleTOjpegData(maxBytes: UInt) -> Data? {
        var quality = 1.0
        while quality > 0 {
            guard let jpeg = jpegData(compressionQuality: quality)
            else { return nil }
            if jpeg.count <= maxBytes {
                return jpeg
            }
            quality -= 0.1
        }
        return nil
    }
}

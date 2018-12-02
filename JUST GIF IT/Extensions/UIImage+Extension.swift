//
//  UIImage+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension UIImage {
    func isPlaceholder() -> Bool {
        return self == UIImage(named: "UserPlaceholder")
    }
    
    func imageData(maxFileSizeMB: Float) -> Data? {
        var compression: CGFloat = 1
        let maxCompression: CGFloat = 0.1
        let maxFileSize = Int(maxFileSizeMB * 1024 * 1024)
        
        var imageData = self.jpegData(compressionQuality: compression)
        
        while ((imageData?.count) ?? 0 > maxFileSize && compression > maxCompression) {
            compression -= 0.1
            imageData = self.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    func resizeImage(maxSide: CGFloat = 1024.0) -> UIImage? {
    
        let actualHeight = self.size.height
        let actualWidth = self.size.width
        
        if (actualWidth <= maxSide && actualHeight <= maxSide) {
            return self
        }
        
        let ratio = actualHeight / actualWidth
        var newHeight: CGFloat
        var newWidth: CGFloat
        
        if (actualHeight >= actualWidth) {
            newHeight = maxSide
            newWidth = newHeight / ratio
        } else {
            newWidth = maxSide
            newHeight = newWidth * ratio
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}

//
//  UIImage+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

//MARK: - Constants
extension UIImage {
    class func userPlaceholder() -> UIImage {
        guard let image = UIImage(named: "UserPlaceholder") else {
            fatalError("UserPlaceholder image unwrapping error")
        }
        return image
    }
    
    class func picturePlaceholder() -> UIImage {
        guard let image = UIImage(named: "PicturePlaceholder") else {
            fatalError("PicturePlaceholder image unwrapping error")
        }
        return image
    }
}

//MARK: - Helpers
extension UIImage {
    func isPlaceholder() -> Bool {
        return self == UIImage.userPlaceholder() || self == UIImage.picturePlaceholder()
    }
    
    func resizeImage(maxSide: CGFloat = 1024.0) -> UIImage? {
    
        let actualHeight = size.height
        let actualWidth = size.width
        
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
        draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}

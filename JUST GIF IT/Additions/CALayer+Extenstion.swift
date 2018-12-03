//
//  CALayer+Extenstion.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension CALayer {
    func setAppBorder() {
        setBorder(color: .orange, width: 1.0)
    }
    
    func setBorder(color: UIColor, width: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.borderColor = color.cgColor
            self?.borderWidth = width
        }
    }
    
    func setCorner(radius: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.cornerRadius = radius
        }
    }
}

//
//  UIButton+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension UIButton {
    func setAppStyle() {
        DispatchQueue.main.async { [weak self] in
            self?.imageView?.contentMode = .scaleAspectFit
            self?.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        layer.setCorner(radius: 20.0)
        layer.setAppBorder()
    }
}

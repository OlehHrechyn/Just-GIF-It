//
//  UITextField+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension UITextField {
    func setAppStyle() {
        layer.setCorner(radius: 10.0)
        layer.setAppBorder()
        DispatchQueue.main.async { [weak self] in
            self?.clipsToBounds = true
        }
    }
}

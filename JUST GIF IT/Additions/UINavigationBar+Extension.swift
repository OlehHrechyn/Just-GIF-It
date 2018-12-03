//
//  UIButton+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setAppStyle() {
        setGradientBackground(colors: [.darkGray, .black])
    }
    
    func setGradientBackground(colors: [UIColor]) {
        DispatchQueue.main.async { [weak self] in
            var updatedFrame = self?.bounds
            updatedFrame?.size.height += self?.frame.origin.y ?? 0
            let gradientLayer = CAGradientLayer(frame: updatedFrame ?? CGRect.zero, colors: colors)
            self?.setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
        }
    }
}

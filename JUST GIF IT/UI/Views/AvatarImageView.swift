//
//  AvatarImageView.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {
    override func layoutSubviews() {
        layer.setCorner(radius: bounds.height / 2)
        layer.setAppBorder()
        DispatchQueue.main.async { [weak self] in
            self?.clipsToBounds = true
        }
    }
}

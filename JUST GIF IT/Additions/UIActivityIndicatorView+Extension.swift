//
//  UIActivityIndicatorView+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 11/28/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func start() {
        DispatchQueue.main.async { [weak self] in
            self?.startAnimating()
        }
    }
    
    func stop() {
        DispatchQueue.main.async { [weak self] in
            self?.stopAnimating()
        }
    }
}

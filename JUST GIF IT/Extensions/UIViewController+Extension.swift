//
//  UIViewController+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 11/26/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

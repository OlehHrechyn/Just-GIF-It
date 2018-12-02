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
    
    func showAlert(error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }

    }
}

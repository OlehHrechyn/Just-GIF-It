//
//  UIViewController+Additions.swift
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


protocol ImagePickerConforming  {
    var imagePicker: UIImagePickerController { get set }
    
}

extension ImagePickerConforming where Self: UIViewController {
    
    func showImagePickerAlert() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.imagePicker.sourceType = .camera
                self?.presentImagePicker()
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.imagePicker.sourceType = .photoLibrary
            self?.presentImagePicker()
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentImagePicker() {
        DispatchQueue.main.async { [weak self] in
            if let imagePicker = self?.imagePicker {
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
}

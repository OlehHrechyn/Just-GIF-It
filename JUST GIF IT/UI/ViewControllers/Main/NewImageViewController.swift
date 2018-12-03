//
//  NewImageViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/27/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class NewImageViewController: UIViewController, ImagePickerConforming {
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    private enum TextFieldType: Int {
        case description = 0
        case hashtag
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var hashtagTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
}

//MARK: - Lifecycle
extension NewImageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupUI()
    }
    
}

//MARK: - IBActions
extension NewImageViewController {
    
    @IBAction func imageViewDidTape(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        showImagePickerAlert()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        activityView.start()
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        
        ImageManager.shared.uploadImage(imageView.image, description: descriptionTextField.text, hashtag: hashtagTextField.text) { [weak self] (error) in
            self?.activityView.stop()
            self?.view.isUserInteractionEnabled = true
            self?.navigationController?.navigationBar.isUserInteractionEnabled = true
            if let error = error {
                self?.showAlert(error: error)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK: - Private
extension NewImageViewController {
    func setupLogic() {
        descriptionTextField.tag = TextFieldType.description.rawValue
        hashtagTextField.tag = TextFieldType.hashtag.rawValue
        hideKeyboardOnTap()
        imagePicker.delegate = self
        imagePicker.navigationBar.setAppStyle()
    }
    
    func setupUI() {
        descriptionTextField.setAppStyle()
        hashtagTextField.setAppStyle()
        imageView.layer.setAppBorder()
        imageView.layer.setCorner(radius: 10.0)
    }
}


//MARK: - UITextFieldDelegate
extension NewImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension NewImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = pickedImage.resizeImage(maxSide: 1080.0)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

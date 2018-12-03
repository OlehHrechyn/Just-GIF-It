//
//  RegisterViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, SegueCustomPerform, ImagePickerConforming {
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    private enum TextFieldType: Int {
        case username = 0
        case email
        case password
    }
    
    @IBOutlet private weak var avatarImageView: AvatarImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    
}

//MARK: - Lifecycle
extension RegisterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupUI()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - IBActions
private extension RegisterViewController {
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        activityView.start()
        UserManager.register(username: usernameTextField.text, email: emailTextField.text, password: passwordTextField.text, avatar: avatarImageView.image) { [weak self] (error) in
            self?.activityView.stop()
            if let error = error {
                self?.showAlert(error: error)
            } else {
                self?.performSegue(withIdentifier: .toMainStoryboard, sender: nil)
            }
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func avatarImageViewDidTapped(_ sender: UITapGestureRecognizer) {
        showImagePickerAlert()
    }
}

//MARK: - Private
private extension RegisterViewController {
    func setupLogic() {
        usernameTextField.tag = TextFieldType.username.rawValue
        emailTextField.tag = TextFieldType.email.rawValue
        passwordTextField.tag = TextFieldType.password.rawValue
        hideKeyboardOnTap()
        setupImagePicker()
    }
    
    func setupUI() {
        usernameTextField.setAppStyle()
        emailTextField.setAppStyle()
        passwordTextField.setAppStyle()
        registerButton.setAppStyle()
        signInButton.setAppStyle()
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.setAppStyle()
    }
    
}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageView.image = pickedImage.resizeImage(maxSide: 512.0)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

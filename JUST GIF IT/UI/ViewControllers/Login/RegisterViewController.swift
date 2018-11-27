//
//  RegisterViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
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

    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func avatarImageViewDidTapped(_ sender: UITapGestureRecognizer) {
        
    }
}

//MARK: - Private
private extension RegisterViewController {
    func setupLogic() {
        usernameTextField.tag = TextFieldType.username.rawValue
        emailTextField.tag = TextFieldType.email.rawValue
        passwordTextField.tag = TextFieldType.password.rawValue
        hideKeyboardOnTap()
    }
    
    func setupUI() {
        usernameTextField.setAppStyle()
        emailTextField.setAppStyle()
        passwordTextField.setAppStyle()
        registerButton.setAppStyle()
        signInButton.setAppStyle()
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
    
}

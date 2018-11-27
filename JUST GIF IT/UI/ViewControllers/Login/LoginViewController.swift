//
//  LoginViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private enum TextFieldType: Int {
        case email = 0
        case password
    }
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    
}

//MARK: - Lifecycle
extension LoginViewController {
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
private extension LoginViewController {
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.toMainStoryboard.rawValue, sender: nil)
    }
}

//MARK: - Private
private extension LoginViewController {
    func setupLogic() {
        emailTextField.tag = TextFieldType.email.rawValue
        passwordTextField.tag = TextFieldType.password.rawValue
        hideKeyboardOnTap()
    }
    
    func setupUI() {
        emailTextField.setAppStyle()
        passwordTextField.setAppStyle()
        loginButton.setAppStyle()
        signUpButton.setAppStyle()
    }
    
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

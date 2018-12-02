//
//  LoginViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SegueCustomPerform {

    private enum TextFieldType: Int {
        case email = 0
        case password
    }
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    
}

//MARK: - Lifecycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupUI()
        
        setupDebugData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - IBActions
private extension LoginViewController {
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        activityView.start()
        UserManager.login(email: emailTextField.text, password: passwordTextField.text) { [weak self] (error) in
            self?.activityView.stop()
            if let error = error {
                self?.showAlert(error: error)
            } else {
                self?.performSegue(withIdentifier: .toMainStoryboard, sender: nil)
            }
        }
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
    
    func setupDebugData() {
        if AppManager.isDebug {
            emailTextField.text = "test3@gmail.com"
            passwordTextField.text = "qqq"
        }
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

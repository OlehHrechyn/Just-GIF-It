//
//  AppManager.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum StoryboardType: String {
    case login = "Login"
    case main = "Main"
}

class AppManager {
    final class func setupInitials() {
        setupKeyboard()
        setupAppearance()
    }
    
    final class func setupNecessaryViewController(window: UIWindow?) {
        guard let window = window else { return }
        let vc = AppManager.necessaryViewController()
        window.rootViewController = vc
    }
}


//MARK: - Private
private extension AppManager {
    class func necessaryViewController() -> UIViewController? {
        var storyboard: UIStoryboard
        if let token = UserManager.token(), token.isEmpty == false {
            storyboard = UIStoryboard(name: StoryboardType.main.rawValue, bundle: nil)
        } else {
            storyboard = UIStoryboard(name: StoryboardType.login.rawValue, bundle: nil)
        }
        return storyboard.instantiateInitialViewController()
    }
    
    class func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    class func setupAppearance() {
        UINavigationBar.appearance().tintColor = .orange
    }
}

//
//  UserManager.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserManager {
    
    final class func login(email: String?, password: String?, completion: @escaping ErrorCompletion) {
        guard let email = email, !email.isEmpty else {
            completion(InternalError.blank(APIManager.emailKey.capitalized))
            return
        }
        
        guard email.isValidEmail() else {
            completion(InternalError.invalid(APIManager.emailKey.capitalized))
            return
        }
        
        guard let password = password, !password.isEmpty else {
            completion(InternalError.blank(APIManager.passwordKey.capitalized))
            return
        }
        
        guard password.isValidPassword() else {
            completion(InternalError.invalid(APIManager.passwordKey.capitalized))
            return
        }
        
        APIManager.login(email: email, password: password) { (user, error) in
            if let user = user, let token = user.token {
                KeychainManager.saveToken(token)
            }
            completion(error)
        }
        
    }
    
    final class func register(username:String?, email: String?, password: String?, avatar: UIImage?, completion: @escaping ErrorCompletion) {
        guard let email = email, !email.isEmpty else {
            completion(InternalError.blank(APIManager.emailKey.capitalized))
            return
        }
        
        guard email.isValidEmail() else {
            completion(InternalError.invalid(APIManager.emailKey.capitalized))
            return
        }
        
        guard let password = password, !password.isEmpty else {
            completion(InternalError.blank(APIManager.passwordKey.capitalized))
            return
        }
        
        guard password.isValidPassword() else {
            completion(InternalError.invalid(APIManager.passwordKey.capitalized))
            return
        }
        
        guard let avatar = avatar, !avatar.isPlaceholder() else {
            completion(InternalError.blank(APIManager.avatarKey.capitalized))
            return
        }
        
        APIManager.register(username: username ?? "", email: email, password: password, avatar: avatar) { (user, error) in
            if let user = user, let token = user.token {
                KeychainManager.saveToken(token)
            }
            completion(error)
        }
        
    }
    
    final class func logout() {
        KeychainManager.deleteToken()
        ImageManager.shared.clear()
    }
}

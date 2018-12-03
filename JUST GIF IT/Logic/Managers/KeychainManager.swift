//
//  User.swift
//  JUST GIF IT
//
//  Created by Developer on 11/29/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainManager {
    private static let tokenKey = "token"
    
    final class func getToken() -> String? {
        return KeychainSwift().get(tokenKey)
    }
    
    final class func saveToken(_ token: String) {
        KeychainSwift().set(token, forKey: tokenKey)
    }
    
    final class func deleteToken() {
        KeychainSwift().delete(tokenKey)
    }
}

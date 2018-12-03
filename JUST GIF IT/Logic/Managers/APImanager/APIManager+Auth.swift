//
//  APIManager+Auth.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

//MARK: - Auth Functionality
extension APIManager {
    static let usernameKey = "username"
    static let emailKey = "email"
    static let passwordKey = "password"
    static let avatarKey = "avatar"
    
    static let colonSpaceKey = ": "
    typealias UserModelCompletion = (_ user: User?, _ error: Error?) -> Void
    
    final class func login(email: String, password: String, completion: @escaping UserModelCompletion) {
        let url = baseUrl + EndPoint.auth.login.rawValue
        var parameters = Parameters()
        parameters[emailKey] = email
        parameters[passwordKey] = password
        
        APIManager.request(url: url, method: .post, parameters: parameters) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(User(JSON: response), nil)
        }
    }
    
    final class func register(username: String, email: String, password: String, avatar: UIImage, completion: @escaping UserModelCompletion) {
        let url = baseUrl + EndPoint.auth.register.rawValue
        var parameters = Parameters()
        parameters[usernameKey] = username
        parameters[emailKey] = email
        parameters[passwordKey] = password
        parameters[avatarKey] = avatar
        
        APIManager.upload(url: url, parameters: parameters) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            let errorMessage = APIManager.registrationErrorMessage(response: response)
            if errorMessage.isEmpty {
                completion(User(JSON: response), nil)
            } else {
                completion(nil, InternalError.custom(errorMessage))
            }
        }
    }
    
}

//MARK: - Response errors
private extension APIManager {
    final class func registrationErrorMessage(response: [String: Any]) -> String {
        var errorMessages = [String]()
        let json = JSON(arrayLiteral: response)
        
        if let avatarError = json.array?.first?[childrenKey][avatarKey][errorsKey].array?.first?.string {
            errorMessages.append(avatarKey.capitalized + colonSpaceKey + avatarError)
        }
        if let emailError = json.array?.first?[childrenKey][emailKey][errorsKey].array?.first?.string {
            errorMessages.append(emailKey.capitalized + colonSpaceKey + emailError)
        }
        if let passwordError = json.array?.first?[childrenKey][passwordKey][errorsKey].array?.first?.string {
            errorMessages.append(passwordKey.capitalized + colonSpaceKey + passwordError)
        }
        
        return errorMessages.joined(separator: " ")
    }
}

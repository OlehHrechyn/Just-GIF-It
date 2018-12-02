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
    
    final class func login(email: String, password: String, completion: @escaping UserModelCompletion) {
        let url = baseUrl + EndPoint.auth.login.rawValue
        var parameters = Parameters()
        parameters["email"] = email
        parameters["password"] = password
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (responseObject) in
            guard responseObject.result.isSuccess else {
                completion(nil, responseObject.error)
                return
            }
            guard let response = responseObject.result.value as? [String : Any] else {
                completion(nil, InternalError.JSONParseError)
                return
            }
            
            let errorMessage = APIManager.loginErrorMessage(response: response)
            if errorMessage.isEmpty {
                completion(User(JSON: response), nil)
            } else {
                completion(nil, InternalError.custom(errorMessage))
            }
            
        }
        
    }
    
    final class func register(username: String, email: String, password: String, avatar: UIImage, completion: @escaping UserModelCompletion) {
        let url = baseUrl + EndPoint.auth.register.rawValue
        var parameters = Parameters()
        parameters["username"] = username
        parameters["email"] = email
        parameters["password"] = password
        parameters["avatar"] = avatar
        
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
extension APIManager {
    final class func loginErrorMessage(response: [String:Any]) -> String {
        return response["error"] as? String ?? ""
    }
    
    final class func registrationErrorMessage(response: [String:Any]) -> String {
        var errorMessages = [String]()
        let json = JSON(arrayLiteral: response)
        
        if let avatarError = json.array?.first?["children"]["avatar"]["errors"].array?.first?.string {
            errorMessages.append("Avatar: " + avatarError)
        }
        if let emailError = json.array?.first?["children"]["email"]["errors"].array?.first?.string {
            errorMessages.append("Email: " + emailError)
        }
        if let passwordError = json.array?.first?["children"]["password"]["errors"].array?.first?.string {
            errorMessages.append("Password: " + passwordError)
        }
        
        return errorMessages.joined(separator: " ")
    }
}

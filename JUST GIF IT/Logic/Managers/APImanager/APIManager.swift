//
//  APIManager.swift
//  JUST GIF IT
//
//  Created by Developer on 11/27/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import Alamofire

typealias ErrorCompletion = (_ error: Error?) -> Void
typealias RequestCompletion = (_ response: [String: Any]?, _ error: Error?) -> Void

class APIManager {
    static let baseUrl = "http://api.doitserver.in.ua"
    static let tokenKey = "token"
    
    enum EndPoint {
        enum auth: String {
            case login = "/login"
            case register = "/create"
        }
        enum image: String {
            case all = "/all"
            case gif = "/gif"
            case immage = "/image"
        }
    }
    
    
}

//MARK: - Common methods
extension APIManager {
    final class func request(url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON { responseObject in
            guard responseObject.result.isSuccess else {
                completion(nil, responseObject.error)
                return
            }
            guard let response = responseObject.result.value as? [String : Any] else {
                completion(nil, InternalError.JSONParseError)
                return
            }
            let errorMessage = APIManager.commonErrorMessage(response: response)
            if errorMessage.isEmpty {
                completion(response, nil)
            } else {
                completion(nil, InternalError.custom(errorMessage))
            }
            completion(response, nil)
        }
    }
    
    final class func upload(url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders = [:], parameters: Parameters, completion: @escaping RequestCompletion) {
        guard let url = try? URLRequest(url: url, method: .post, headers: headers) else {
            fatalError("URL unwrapping error")
        }
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let image = value as? UIImage, let data = image.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(data, withName: key, fileName: "file.jpg", mimeType: "image/jpeg")
                } else if let string = value as? String, let data = string.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, with: url,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { responseObject in
                    guard responseObject.result.isSuccess else {
                        completion(nil, responseObject.error)
                        return
                    }
                    guard let response = responseObject.result.value as? [String : Any] else {
                        completion(nil, InternalError.JSONParseError)
                        return
                    }
                    let errorMessage = APIManager.commonErrorMessage(response: response)
                    if errorMessage.isEmpty {
                        completion(response, nil)
                    } else {
                        completion(nil, InternalError.custom(errorMessage))
                    }

                    completion(response, nil)
                }
            case .failure( _):
                break
            }
        }
        )
    }
}

//MARK: - Response errors
extension APIManager {
    final class func commonErrorMessage(response: [String:Any]) -> String {
        return response["error"] as? String ?? ""
    }
}

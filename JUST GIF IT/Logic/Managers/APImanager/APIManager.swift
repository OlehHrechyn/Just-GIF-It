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
typealias UserModelCompletion = (_ user: User?, _ error: Error?) -> Void

class APIManager {
    static let baseUrl = "http://api.doitserver.in.ua"
    
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

//MARK: - Common
extension APIManager {
    final class func upload(url: URLConvertible, parameters: Parameters, method: HTTPMethod = .post, headers: HTTPHeaders = [:], completion: @escaping RequestCompletion) {
        let url = try! URLRequest(url: url, method: .post, headers: headers)
        
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
                    completion(response, nil)
                }
            case .failure( _):
                break
            }
        }
        )
    }
}

//
//  APIManager+Image.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

extension APIManager {
    typealias GetRequestImageCompletion = (_ image: [GetRequestImage]?, _ error: Error?) -> Void
    typealias UploadRequestImageCompletion = (_ image: UploadRequestImage?, _ error: Error?) -> Void
    typealias GifURLCompletion = (_ gifURL: URL?, _ error: Error?) -> Void

    final class func getAllImages(completion: @escaping GetRequestImageCompletion) {
        let url = baseUrl + EndPoint.image.all.rawValue
        var headers = HTTPHeaders()
        headers[APIManager.tokenKey] = KeychainManager.getToken()
        
        APIManager.request(url: url, method: .get, headers: headers) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            var images: [GetRequestImage] = []
            let json = JSON(arrayLiteral: response)
            if let responseImages = json.array?.first?["images"].array {
                for responseImage in responseImages {
                    if let imageDict = responseImage.dictionaryObject, let image = GetRequestImage(JSON: imageDict) {
                        images.append(image)
                    }
                }
            }
            completion(images, nil)
        }
    }
    
    final class func getGifLink(completion: @escaping GifURLCompletion) {
        let url = baseUrl + EndPoint.image.gif.rawValue
        var headers = HTTPHeaders()
        headers[APIManager.tokenKey] = KeychainManager.getToken()
        
        APIManager.request(url: url, method: .get, headers: headers) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            if let gifString = response["gif"] as? String, let gifURL = URL(string: gifString) {
                completion(gifURL, nil)
            } else {
                completion(nil, InternalError.custom("Invalid GIF link"))
            }
        }
    }
    
    final class func uploadImage() {
        
    }
}

//MARK: - Response errors
extension APIManager {
    final class func uploadImageErrorMessage(response: [String: Any]) -> String {
        var errorMessages = [String]()
        let json = JSON(arrayLiteral: response)
        
        if let avatarError = json.array?.first?["children"]["image"]["errors"].array?.first?.string {
            errorMessages.append("Image: " + avatarError)
        }
        if let emailError = json.array?.first?["children"]["latitude"]["errors"].array?.first?.string {
            errorMessages.append("Latitude: " + emailError)
        }
        if let passwordError = json.array?.first?["children"]["longitude"]["errors"].array?.first?.string {
            errorMessages.append("Longitude: " + passwordError)
        }
        
        return errorMessages.joined(separator: " ")
    }
}

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
    static let imageKey = "image"
    static let gifKey = "gif"
    
    static let imagesKey = "images"
    static let descriptionKey = "description"
    static let hashtagKey = "hashtag"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    
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
            if let responseImages = json.array?.first?[imagesKey].array {
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
            
            if let gifString = response[gifKey] as? String, let gifURL = URL(string: gifString) {
                completion(gifURL, nil)
            } else {
                completion(nil, InternalError.custom("Invalid GIF link"))
            }
        }
    }
    
    final class func uploadImage(_ image: UIImage, description: String, hashtag: String, latitude: Double, longitude: Double, completion: @escaping UploadRequestImageCompletion) {
        
        let url = baseUrl + EndPoint.image.upload.rawValue
        
        var headers = HTTPHeaders()
        headers[APIManager.tokenKey] = KeychainManager.getToken()
        
        var parameters = Parameters()
        parameters[imageKey] = image
        parameters[descriptionKey] = description
        parameters[hashtagKey] = hashtag
        parameters[latitudeKey] = "\(latitude)"
        parameters[longitudeKey] = "\(longitude)"
        
        APIManager.upload(url: url, headers: headers, parameters: parameters) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            let errorMessage = APIManager.uploadImageErrorMessage(response: response)
            if errorMessage.isEmpty {
                completion(UploadRequestImage(JSON: response), nil)
            } else {
                completion(nil, InternalError.custom(errorMessage))
            }
        }
    }
}

//MARK: - Response errors
private extension APIManager {
    final class func uploadImageErrorMessage(response: [String: Any]) -> String {
        var errorMessages = [String]()
        let json = JSON(arrayLiteral: response)
        
        if let avatarError = json.array?.first?[childrenKey][imageKey][errorsKey].array?.first?.string {
            errorMessages.append(imageKey.capitalized + colonSpaceKey + avatarError)
        }
        if let emailError = json.array?.first?[childrenKey][latitudeKey][errorsKey].array?.first?.string {
            errorMessages.append(latitudeKey.capitalized + colonSpaceKey + emailError)
        }
        if let passwordError = json.array?.first?[childrenKey][longitudeKey][errorsKey].array?.first?.string {
            errorMessages.append(longitudeKey.capitalized + colonSpaceKey + passwordError)
        }
        
        return errorMessages.joined(separator: " ")
    }
}

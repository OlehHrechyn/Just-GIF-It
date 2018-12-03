//
//  Images.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - Local image
struct LocalImageModel: Equatable {
    var latitude: Double?
    var longitude: Double?
    var image: UIImage?
    var description: String?
    var hashtag: String?
    var weather: String?
    var smallImagePath: String?
    var bigImagePath: String?
    
    var address: String?
}


//MARK: - Server Images
struct GetRequestImage: Mappable {
    var id: Int?
    var description: String?
    var hashtag: String?
    var parameters: GetRequestImageParameters?
    var smallImagePath: String?
    var bigImagePath: String?
    var created: String?
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        description     <- map["description"]
        hashtag         <- map["hashtag"]
        parameters      <- map["parameters"]
        smallImagePath  <- map["smallImagePath"]
        bigImagePath    <- map["bigImagePath"]
        created         <- map["created"]
    }
}


struct GetRequestImageParameters: Mappable {
    var latitude: Double?
    var longitude: Double?
    var weather: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
        weather     <- map["weather"]
    }
    
}

struct UploadRequestImage: Mappable {
    var parameters: UploadRequestImageParameters?
    var smallImage: String?
    var bigImage: String?
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        parameters  <- map["parameters"]
        smallImage  <- map["smallImage"]
        bigImage    <- map["bigImage"]
    }
}


struct UploadRequestImageParameters: Mappable {
    var address: String?
    var weather: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        address <- map["address"]
        weather <- map["weather"]
    }
    
}

//
//  User.swift
//  JUST GIF IT
//
//  Created by Developer on 12/1/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
    var token: String?
    var avatar: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        token   <- map[APIManager.tokenKey]
        avatar  <- map[APIManager.avatarKey]
    }
}


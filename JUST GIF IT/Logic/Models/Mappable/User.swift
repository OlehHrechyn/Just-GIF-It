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
    var creationTime: String?
    var token: String?
    var avatar: String?
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        creationTime    <- map["creation_time"]
        token           <- map["token"]
        avatar          <- map["avatar"]
    }
}


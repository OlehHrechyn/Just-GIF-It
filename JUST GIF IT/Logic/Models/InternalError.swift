//
//  InternalError.swift
//  JUST GIF IT
//
//  Created by Developer on 11/28/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

enum InternalError: LocalizedError {
    case blank(_ string: String)
    case invalid(_ string: String)
    case somethingWrong
    case JSONParseError
    case gpsError
    
    case custom(_ description: String?)
}

extension InternalError {
    var errorDescription: String? {
        switch self {
        case .blank(let string):
            return "\(string) is required"
        case .invalid(let string):
            return "\(string) is invalid"
        case .somethingWrong:
            return "Something went wrong"
        case .JSONParseError:
            return "JSON parse error"
        case .gpsError:
            return "Please enable the location detecting"
            
        case .custom(let description):
            if let description = description {
                return description
            } else {
                return InternalError.somethingWrong.errorDescription
            }
        }
    }
}

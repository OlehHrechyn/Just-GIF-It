//
//  LocationManager.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
}

//MARK: - Public
extension LocationManager {
    final class func getPlaceName(latitude: Float?, longitude: Float?) -> String {
        guard let latitude = latitude, let longitude = longitude else {
            return "NO INFO"
        }
        
        return "\(latitude), \(longitude)"
    }
}

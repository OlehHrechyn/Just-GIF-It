//
//  LocationManager.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    typealias LocationCompletion = (_ location: CLLocation) -> Void
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: LocationCompletion?
}

//MARK: - Public
extension LocationManager {
    final class func coordinatesString(latitude: Double?, longitude: Double?) -> String {
        guard let latitude = latitude, let longitude = longitude else {
            return "NO INFO"
        }
        let latStr = String(format: "%.5f", latitude)
        let lonStr = String(format: "%.5f", longitude)
        return "\(latStr), \(lonStr)"
    }
    
    final class func getPlaceName(latitude: Double?, longitude: Double?, completion: @escaping (_ address: String?, _ error: Error?) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placeMarks, error) in
            if let placeMarks = placeMarks, let placeMark = placeMarks.last {
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                var addresses = [String]()
                if let city = placeMark.locality {
                    addresses.append(city)
                }
                if let country = placeMark.country {
                    addresses.append(country)
                }
                
                let address = addresses.joined(separator: ", ")
                completion(address, nil)
            }
        }
    }
}

extension LocationManager {
    
    class func locationServicesEnabledOrNotDetermined() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                return true
            }
        } else {
            return false
        }
    }
    
    func getCurrentLocation(completion: @escaping(LocationCompletion)) {
        locationCompletion = completion
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        if let locationCompletion = locationCompletion {
            locationCompletion(location)
        }
        
    }
    
}

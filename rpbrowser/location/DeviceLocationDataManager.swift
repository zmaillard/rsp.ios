//
//  DeviceLocationDataManager.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/16/26.
//

import Foundation
import CoreLocation
internal import Combine

class DeviceLocationDataManager : NSObject, CLLocationManagerDelegate, LocationDataManager {
    var locationDataManager = CLLocationManager()
    
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    
    override init() {
        super.init()
        locationDataManager.delegate = self
    }
    
    enum LocationManagerError: String, Error {
        case replaceContinuation = "Continuation replaced"
        case locationNotFound = "No location found"
    }
    
    
    var currentLocation: CLLocation {
        get async throws {
            if self.continuation != nil {
                self.continuation?.resume(throwing: LocationManagerError.replaceContinuation)
                self.continuation = nil
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                locationDataManager.requestLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            continuation?.resume(returning: location)
            continuation = nil
        } else {
            continuation?.resume(throwing: LocationManagerError.locationNotFound)
        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: // Location services available
            authorizationStatus = .authorizedWhenInUse
            manager.requestLocation()
            break;
        case .restricted: // Location services not-available
            authorizationStatus = .restricted
            break;
        case .denied: // Location services not-available - denied
            authorizationStatus = .denied
            break;
        case .notDetermined: // Location services not-available
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break;
        default:
            break;
            
        }
    }
}


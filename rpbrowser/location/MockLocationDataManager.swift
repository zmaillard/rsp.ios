//
//  LocationDataManager.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/15/26.
//
import CoreLocation

struct MockLocationDataManager: LocationDataManager {
    var currentLocation: CLLocation {
      return CLLocation(latitude: 43.609506, longitude: -116.277111)
    }
}

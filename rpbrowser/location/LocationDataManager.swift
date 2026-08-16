//
//  LocationDataManager.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/15/26.
//
import CoreLocation

protocol LocationDataManager {
    var currentLocation: CLLocation {get async throws}
}
    


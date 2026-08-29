//
//  Coordinates.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/27/26.
//

import Foundation
import MapLibre
import CoreLocation

struct Rectangle : Hashable, Codable, Equatable {
    let lowerLeft: Coordinates
    let upperRight: Coordinates
    
    static func from(mapView: MLNCoordinateBounds) -> Rectangle {
        return Rectangle(lowerLeft: Coordinates.from(mapView: mapView.sw), upperRight: Coordinates.from(mapView: mapView.ne))
    }
    
    private static func roundPrecision(_ value: Double) -> Double {
        return Double(round(1000 * value) / 1000)
    }
    
    
    // Set equality to three decimal places to prevent constant refresh triggers
    static func == (lhs: Rectangle, rhs: Rectangle) -> Bool {
        return roundPrecision(lhs.upperRight.latitude) ==  roundPrecision(rhs.upperRight.latitude) &&
        roundPrecision(lhs.upperRight.longitude) ==  roundPrecision(rhs.upperRight.longitude) &&
        roundPrecision(lhs.lowerLeft.latitude) == roundPrecision(rhs.lowerLeft.latitude) &&
        roundPrecision(lhs.lowerLeft.longitude) ==  roundPrecision(rhs.lowerLeft.longitude)
    }
}

struct Coordinates : Hashable, Codable, Equatable {
    let latitude: Double
    let longitude: Double
    
    static func from(location: CLLocation) -> Coordinates {
        return Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    static func from(mapView: CLLocationCoordinate2D) -> Coordinates {
        return Coordinates(latitude: mapView.latitude, longitude: mapView.longitude)
    }
}

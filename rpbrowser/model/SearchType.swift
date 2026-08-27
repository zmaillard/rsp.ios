//
//  SearchType.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import CoreLocation
import MapLibre

struct Rectangle : Hashable, Codable, Equatable {
    let lowerLeft: Coordinates
    let upperRight: Coordinates
    
    static func from(mapView: MLNCoordinateBounds) -> Rectangle {
        return Rectangle(lowerLeft: Coordinates.from(mapView: mapView.sw), upperRight: Coordinates.from(mapView: mapView.ne))
    }
    
    private static func roundPrecision(_ value: Double) -> Double {
        return Double(round(1000 * value) / 1000)
    }
    
    
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

enum SearchType : Hashable, Codable {
    case StateFilter(String)
    case StateSubdivisionFilter(String)
    case PlaceFilter(String)
    case Term(String)
    case Location(Coordinates)
    case BoundingBox(Coordinates, Coordinates)
    
    func query() throws -> Any {
        switch self {
        case .Term(let searchTerm):
                return ["queries": [["indexUid": "signs", "q": searchTerm, "facets": []]]]
        case .StateSubdivisionFilter(let stateSubFilter):
            let items = stateSubFilter.split(separator: "_")
            
            guard items.count == 2 else {
                throw APIError.invalidURL
            }
            let filter = "state.slug=\(items[0]) AND county.slug=\(items[1])"
            return ["queries": [["indexUid": "signs", "q": "", "filter":filter, "facets":[]]]]
        case .PlaceFilter(let placeFilter):
            let items = placeFilter.split(separator: "_")
            
            guard items.count == 2 else {
                throw APIError.invalidURL
            }
            let filter = "state.slug=\(items[0]) AND place.slug=\(items[1])"
            return ["queries": [["indexUid": "signs", "q": "", "filter":filter, "facets":[]]]]
        case .StateFilter(let stateFilter):
            let filter = "state.slug=\(stateFilter)"
            return ["queries": [["indexUid": "signs", "q": "", "filter":filter, "facets":[]]]]
        case .Location(let coords):
            let filter = ["_geoRadius(\(coords.latitude),\(coords.longitude),5000)"]
            return ["queries": [["indexUid": "signs", "filter":filter]]]
        case .BoundingBox(let lowerLeft, let upperRight):
            let filter = ["_geoBoundingBox([\(upperRight.latitude),\(upperRight.longitude)], [\(lowerLeft.latitude),\(lowerLeft.longitude)])"]
            print (filter)
            return ["queries": [["indexUid": "signs", "filter":filter]]]
        }
    }
    
}


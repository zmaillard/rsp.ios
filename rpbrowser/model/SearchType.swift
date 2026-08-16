//
//  SearchType.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import CoreLocation

enum SearchType : Hashable {
    case StateFilter(String)
    case StateSubdivisionFilter(String)
    case PlaceFilter(String)
    case Term(String)
    case Location(CLLocation)

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
            let filter = ["_geoRadius(\(coords.coordinate.latitude),\(coords.coordinate.longitude),5000)"]
            return ["queries": [["indexUid": "signs", "filter":filter]]]
        }
    }
    
}


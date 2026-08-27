//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation
import CoreLocation
import MapLibre

@Observable
class MapViewModel {
    
    var state: LoadingState<[RoadSign]> = .idle
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetchSigns(for location: Rectangle) async {
        let searchTerm:SearchType = .BoundingBox(location.lowerLeft, location.upperRight)
        

        self.state = .loading
        
        
        do {
            let signs =  try await service.fetchSigns(type: searchTerm)
            self.state = .loaded(signs)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }

    
}


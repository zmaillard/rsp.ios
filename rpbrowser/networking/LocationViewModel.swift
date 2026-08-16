//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation
import CoreLocation

@Observable
class LocationViewModel {
    
    var state: LoadingState<[RoadSign]> = .idle
    var roadSigns: [RoadSign] = []
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetchSigns(for location: CLLocation?) async {
        if (location == nil) {
            self.state = .idle
            return
        }
        let searchTerm:SearchType = .Location(location!)
        
        
        self.state = .loading
        
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
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


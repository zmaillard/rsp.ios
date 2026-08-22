//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation
import CoreLocation
import MapKit

@Observable
class LocationViewModel {
    
    var state: LoadingState<RoadSignLoaded> = .idle
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
        let coordinates = Coordinates.from(location: location!)
        let searchTerm:SearchType = .Location(coordinates)
        
        
        self.state = .loading
        
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
        do {
            var title = "Signs at Current Location";
            if let req = MKReverseGeocodingRequest(location: location!) {
                let mapItems = try? await req.mapItems
                if let mapItem = mapItems?.first {
                    
                    title = mapItem.addressRepresentations?.cityWithContext ?? title
                }
            }
            let signs =  try await service.fetchSigns(type: searchTerm)
            self.state = .loaded(RoadSignLoaded(signs: signs, title: title))
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }

    
}


//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation

@Observable
class RoadSignsViewModel {
    
    
    var state: LoadingState<[RoadSign]> = .idle
    var roadSigns: [RoadSign] = []
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetchSigns(searchType: SearchType) async {
        guard state == .idle else { return }
        self.state = .loading
        do {
            let signs =  try await service.fetchSigns(type: searchType)
            self.state = .loaded(signs)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }

    
}


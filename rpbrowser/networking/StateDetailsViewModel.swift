//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation

@Observable
class StateDetailsViewModel {
    
    var state: LoadingState<StateDetails> = .idle
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }

    
    func fetch(for country: StateSlim) async {
        guard state != .loading else { return }
        self.state = .loading
        do {
            let state =  try await service.fetchState(from: country.url )
            self.state = .loaded(state)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }
    
}




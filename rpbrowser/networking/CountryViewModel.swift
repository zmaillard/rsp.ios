//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation

@Observable
class CountryViewModel {
    
    var state: LoadingState<Index> = .idle
    
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetch() async {
        guard state == .idle else { return }
        self.state = .loading
        do {
            let countries =  try await service.fetchRoot()
            self.state = .loaded(countries)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }
    
}


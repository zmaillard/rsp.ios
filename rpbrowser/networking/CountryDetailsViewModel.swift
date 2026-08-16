//
//  RoadSignsViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/5/26.
//

import Foundation
import Observation

@Observable
class CountryDetailsViewModel {
    var state: LoadingState<Country> = .idle
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }

    
    func fetch(for root: CountrySlim) async {
        guard state != .loading else { return }
        self.state = .loading
        do {
            let country =  try await service.fetchCountry(from: root.url )
            self.state = .loaded(country)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }

    // MARK: - Preview
    static var example: CountryDetailsViewModel {
        let svc = MockSignSearchService()
        let vm = CountryDetailsViewModel(service: svc)
        vm.state = .loaded(Country.example)
        return vm
    }
}




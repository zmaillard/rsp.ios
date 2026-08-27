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
        guard !state.isLoading || state.error != nil else { return }
        print("inside fetch")
        self.state = .loading
        print("loading inside fetch")
        do {
            let state =  try await service.fetchState(from: country.url )
            print("before loaded inside fetch")
            self.state = .loaded(state)
            print("after loaded inside fetch")
        } catch let error as APIError{
            print("before error inside fetch")
            self.state = .error(error.errorDescription ?? "unknown error")
            print("after error inside fetch")
        } catch {
            print("before unhandled error inside fetch")
            self.state = .error("unknown error")
            print("after unhandled error inside fetch")
        }
    }
    
    // MARK: - Preview
    static var example: StateDetailsViewModel {
        let svc = MockSignSearchService()
        let vm = StateDetailsViewModel(service: svc)
        vm.state = .loaded(StateDetails.example)
        return vm
    }
}




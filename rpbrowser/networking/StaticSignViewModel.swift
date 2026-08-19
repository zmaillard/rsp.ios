//
//  RandomViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/12/26.
//
import Foundation

@Observable
class StaticSignViewModel {
    var state: LoadingState<RoadSignDetails> = .idle
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetch(signId: String) async {
        var shouldFetch = false
        if case .loaded = state {
            shouldFetch = true
        } else if .idle == state {
            shouldFetch = true
        }
        
        if !shouldFetch {
            return
        }
        
        
        self.state = .loading
        do {
            let url = "https://roadsign.pictures/sign/\(signId)/index.json"
            let sign = try await self.service.fetchSignDetail(from: url)
            self.state = .loaded(sign)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
            
    }
    
    //MARK: - Preview
    static var example: RandomViewModel {
        let svc = MockSignSearchService()
        let vm = RandomViewModel(service: svc)
        vm.state = .loaded(RoadSignDetails.example)
        return vm
    }
}


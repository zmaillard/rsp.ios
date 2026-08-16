//
//  RandomViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/12/26.
//
import Foundation

@Observable
class RandomViewModel {
    var state: LoadingState<RoadSignDetails> = .idle
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetch(count: Int) async {
        var shouldFetch = false
        if case .loaded = state {
            shouldFetch = true
        } else if .idle == state {
            shouldFetch = true
        }
        
        if !shouldFetch {
            return
        }
        
        if (count == 0) {
            return
        }
        
        self.state = .loading
        do {
            let url = "https://roadsign.pictures/signindex/\(random(max: count))/index.json"
            let randomSign = try await self.service.fetchSignDetail(from: url)
            self.state = .loaded(randomSign)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
        
    }
    
    private func random(max: Int) -> Int {
        return Int.random(in: 0..<max)
    }
    
    //MARK: - Preview
    static var example: RandomViewModel {
        let svc = MockSignSearchService()
        let vm = RandomViewModel(service: svc)
        vm.state = .loaded(RoadSignDetails.example)
        return vm
    }
}


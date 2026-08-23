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
    
    
    var state: LoadingState<RoadSignLoaded> = .idle
    var roadSigns: [RoadSign] = []
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetchSigns(searchType: SearchType) async {
        guard !state.isLoading || state.error != nil else { return }
        self.state = .loading
        do {
            let signs =  try await service.fetchSigns(type: searchType)
            var title = "No Results Found"
            if signs.count > 0 {
               title = getSearchTitle(searchType: searchType, sign: signs[0])
            }
            
            self.state = .loaded(RoadSignLoaded(signs: signs, title: title))
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }

    
    func getSearchTitle(searchType: SearchType, sign: RoadSign) -> String {
        switch searchType {
        case .StateFilter(let state):
            return "Signs from \(sign.state)"
        case .PlaceFilter(let place):
            return "Signs from \(sign.place), \(sign.state)"
        case .StateSubdivisionFilter(let county):
            return "Signs from \(sign.county), \(sign.state)"
        case .Term(let searchTerm):
            return "Search Results for \(searchTerm)"
        case .Location(_):
            return "Signs at Current Location"
        }
    }
}


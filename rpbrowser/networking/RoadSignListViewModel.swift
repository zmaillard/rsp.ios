import Foundation
import Observation


@Observable
class RoadSignListViewModel {
    
    
    var state: LoadingState<StateSubdivision> = .idle
    
    private let service: SignSearchService
    
    init(service: SignSearchService = DefaultSignSearchService()) {
        self.service = service
    }
    
    func fetchSigns(url: String) async {
        guard !state.isLoading || state.error != nil else { return }
        self.state = .loading
        do {
            let stateSubdivision =  try await service.fetchStateSubdivision(from: url)
            self.state = .loaded(stateSubdivision)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }

    
}


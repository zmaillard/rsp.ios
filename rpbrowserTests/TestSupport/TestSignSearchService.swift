import Foundation
@testable import rpbrowser

actor TestSignSearchService: SignSearchService {
    private let rootResult: Result<Index, Error>
    private let countryResult: Result<Country, Error>
    private let stateResult: Result<StateDetails, Error>
    private let signsResult: Result<[RoadSign], Error>
    private let signDetailResult: Result<RoadSignDetails, Error>
    private let stateSubdivisionResult: Result<StateSubdivision, Error>

    private var stateSubdivisionCalls = 0
    private var signsCalls = 0

    init(
        rootResult: Result<Index, Error> = .failure(APIError.invalidResponse),
        countryResult: Result<Country, Error> = .failure(APIError.invalidResponse),
        stateResult: Result<StateDetails, Error> = .failure(APIError.invalidResponse),
        signsResult: Result<[RoadSign], Error> = .failure(APIError.invalidResponse),
        signDetailResult: Result<RoadSignDetails, Error> = .failure(APIError.invalidResponse),
        stateSubdivisionResult: Result<StateSubdivision, Error> = .failure(APIError.invalidResponse)
    ) {
        self.rootResult = rootResult
        self.countryResult = countryResult
        self.stateResult = stateResult
        self.signsResult = signsResult
        self.signDetailResult = signDetailResult
        self.stateSubdivisionResult = stateSubdivisionResult
    }

    func fetchRoot() async throws -> Index {
        try rootResult.get()
    }

    func fetchCountry(from URLString: String) async throws -> Country {
        try countryResult.get()
    }

    func fetchState(from URLString: String) async throws -> StateDetails {
        try stateResult.get()
    }

    func fetchSigns(type: SearchType) async throws -> [RoadSign] {
        signsCalls += 1
        return try signsResult.get()
    }

    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails {
        try signDetailResult.get()
    }

    func fetchStateSubdivision(from URLString: String) async throws -> StateSubdivision {
        stateSubdivisionCalls += 1
        return try stateSubdivisionResult.get()
    }

    func stateSubdivisionCallCount() -> Int {
        stateSubdivisionCalls
    }

    func signsCallCount() -> Int {
        signsCalls
    }
}

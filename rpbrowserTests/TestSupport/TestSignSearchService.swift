import Foundation
@testable import rpbrowser

/// Comprehensive mock service for SignSearchService with call tracking
final class MockSignSearchService: SignSearchService {
    private let rootResult: Result<Index, Error>
    private let countryResult: Result<Country, Error>
    private let stateResult: Result<StateDetails, Error>
    private let signsResult: Result<[RoadSign], Error>
    private let signDetailResult: Result<RoadSignDetails, Error>
    private let stateSubdivisionResult: Result<StateSubdivision, Error>

    // Call tracking
    private var rootCalls = 0
    private var countryCalls = 0
    private var stateCalls = 0
    private var signsCalls = 0
    private var signDetailCalls = 0
    private var stateSubdivisionCalls = 0
    
    // Arguments tracking
    private var lastCountryURL: String?
    private var lastStateURL: String?
    private var lastSignsSearchType: SearchType?
    private var lastSignDetailURL: String?
    private var lastSubdivisionURL: String?

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
        rootCalls += 1
        return try rootResult.get()
    }

    func fetchCountry(from URLString: String) async throws -> Country {
        countryCalls += 1
        lastCountryURL = URLString
        return try countryResult.get()
    }

    func fetchState(from URLString: String) async throws -> StateDetails {
        stateCalls += 1
        lastStateURL = URLString
        return try stateResult.get()
    }

    func fetchSigns(type: SearchType) async throws -> [RoadSign] {
        signsCalls += 1
        lastSignsSearchType = type
        return try signsResult.get()
    }

    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails {
        signDetailCalls += 1
        lastSignDetailURL = URLString
        return try signDetailResult.get()
    }

    func fetchStateSubdivision(from URLString: String) async throws -> StateSubdivision {
        stateSubdivisionCalls += 1
        lastSubdivisionURL = URLString
        return try stateSubdivisionResult.get()
    }

    // MARK: - Call Count Accessors
    
    func rootCallCount() -> Int {
        rootCalls
    }

    func countryCallCount() -> Int {
        countryCalls
    }

    func stateCallCount() -> Int {
        stateCalls
    }

    func signsCallCount() -> Int {
        signsCalls
    }

    func signDetailCallCount() -> Int {
        signDetailCalls
    }

    func stateSubdivisionCallCount() -> Int {
        stateSubdivisionCalls
    }

    // MARK: - Argument Tracking Accessors
    
    func lastCountryURLCalled() -> String? {
        lastCountryURL
    }

    func lastStateURLCalled() -> String? {
        lastStateURL
    }

    func lastSignsSearchTypeCalled() -> SearchType? {
        lastSignsSearchType
    }

    func lastSignDetailURLCalled() -> String? {
        lastSignDetailURL
    }

    func lastSubdivisionURLCalled() -> String? {
        lastSubdivisionURL
    }
}

// MARK: - Test Helpers for Backwards Compatibility

typealias TestSignSearchService = MockSignSearchService

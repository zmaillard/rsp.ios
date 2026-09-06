import XCTest
@testable import rpbrowser

@MainActor
final class StateDetailsViewModelTests: XCTestCase {
    func testFetchLoadsStateDetailsOnSuccess() async {
        let expected = makeStateDetails()
        let service = MockSignSearchServiceForState(stateResult: .success(expected))
        let viewModel = StateDetailsViewModel(service: service)

        await viewModel.fetch(for: makeStateSlim())

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.callCount()
        let lastURL = await service.capturedStateURL()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(lastURL, "https://example.com/state.json")
    }

    func testFetchSetsErrorStateForApiError() async {
        let service = MockSignSearchServiceForState(stateResult: .failure(APIError.invalidURL))
        let viewModel = StateDetailsViewModel(service: service)

        await viewModel.fetch(for: makeStateSlim())

        XCTAssertEqual(viewModel.state, .error("The URL is Invalid"))
    }

    func testFetchSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchServiceForState(stateResult: .failure(MockError.generic))
        let viewModel = StateDetailsViewModel(service: service)

        await viewModel.fetch(for: makeStateSlim())

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchDoesNotStartSecondRequestWhileLoading() async {
        let service = MockSignSearchServiceForState(stateResult: .success(makeStateDetails()))
        let viewModel = StateDetailsViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetch(for: makeStateSlim())

        let callCount = await service.callCount()
        XCTAssertEqual(callCount, 0)
        XCTAssertEqual(viewModel.state, .loading)
    }

    private func makeStateSlim() -> StateSlim {
        StateSlim(
            id: "sample-state",
            name: "Sample State",
            url: "https://example.com/state.json",
            imageCount: 1,
            featured: nil
        )
    }

    private func makeStateDetails() -> StateDetails {
        StateDetails(
            id: "sample-state",
            highways: [
                HighwaySlim(
                    id: "i-90",
                    shield: Shield(large: "https://example.com/i90-large.png", small: "https://example.com/i90-small.png"),
                    name: "Interstate 90",
                    url: "https://example.com/i90.json"
                )
            ],
            name: "Sample State",
            imageCount: 10,
            places: [PlaceSlim(id: "albany", name: "Albany", url: "https://example.com/albany.json", imageCount: 5)],
            stateSubdivisions: [StateSubdivisionSlim(id: "albany-county", name: "Albany County", url: "https://example.com/albany-county.json", imageCount: 5)],
            subdivisionName: "Counties"
        )
    }
}

private actor MockSignSearchServiceForState: SignSearchService {
    private let stateResult: Result<StateDetails, Error>

    private(set) var fetchStateCallCount = 0
    private(set) var lastStateURL: String?

    init(stateResult: Result<StateDetails, Error>) {
        self.stateResult = stateResult
    }

    func callCount() -> Int {
        fetchStateCallCount
    }

    func capturedStateURL() -> String? {
        lastStateURL
    }

    func fetchState(from URLString: String) async throws -> StateDetails {
        fetchStateCallCount += 1
        lastStateURL = URLString
        switch stateResult {
        case .success(let state):
            return state
        case .failure(let error):
            throw error
        }
    }

    func fetchRoot() async throws -> Index { fatalError("Unused in this test") }
    func fetchCountry(from URLString: String) async throws -> Country { fatalError("Unused in this test") }
    func fetchSigns(type: SearchType) async throws -> [RoadSign] { fatalError("Unused in this test") }
    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails { fatalError("Unused in this test") }
    func fetchStateSubdivision(from URLString: String) async throws -> StateSubdivision { fatalError("Unused in this test") }
}

private enum MockError: Error {
    case generic
}

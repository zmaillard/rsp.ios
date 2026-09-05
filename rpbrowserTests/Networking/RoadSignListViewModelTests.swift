import XCTest
@testable import rpbrowser

@MainActor
final class RoadSignListViewModelTests: XCTestCase {
    func testFetchSignsLoadsSubdivisionOnSuccess() async {
        let expected = makeSubdivision()
        let service = MockSignSearchServiceForList(stateSubdivisionResult: .success(expected))
        let viewModel = RoadSignListViewModel(service: service)

        await viewModel.fetchSigns(url: "https://example.com/subdivision.json")

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.callCount()
        let lastURL = await service.capturedSubdivisionURL()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(lastURL, "https://example.com/subdivision.json")
    }

    func testFetchSignsSetsErrorStateForApiError() async {
        let service = MockSignSearchServiceForList(stateSubdivisionResult: .failure(APIError.invalidURL))
        let viewModel = RoadSignListViewModel(service: service)

        await viewModel.fetchSigns(url: "bad-url")

        XCTAssertEqual(viewModel.state, .error("The URL is Invalid"))
    }

    func testFetchSignsSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchServiceForList(stateSubdivisionResult: .failure(MockError.generic))
        let viewModel = RoadSignListViewModel(service: service)

        await viewModel.fetchSigns(url: "https://example.com/subdivision.json")

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchSignsDoesNotStartSecondRequestWhileLoading() async {
        let service = MockSignSearchServiceForList(stateSubdivisionResult: .success(makeSubdivision()))
        let viewModel = RoadSignListViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetchSigns(url: "https://example.com/subdivision.json")

        let callCount = await service.callCount()
        XCTAssertEqual(callCount, 0)
        XCTAssertEqual(viewModel.state, .loading)
    }

    private func makeSubdivision() -> StateSubdivision {
        StateSubdivision(
            id: "sample-county",
            name: "Sample County",
            stateSlug: "sample-state",
            imageCount: 1,
            signs: [RoadSignSlim(id: "img-1", title: "Stop", image: "https://example.com/image.jpg", url: "https://example.com/sign.json")]
        )
    }
}

private actor MockSignSearchServiceForList: SignSearchService {
    private let stateSubdivisionResult: Result<StateSubdivision, Error>

    private(set) var fetchStateSubdivisionCallCount = 0
    private(set) var lastSubdivisionURL: String?

    init(stateSubdivisionResult: Result<StateSubdivision, Error>) {
        self.stateSubdivisionResult = stateSubdivisionResult
    }

    func callCount() -> Int {
        fetchStateSubdivisionCallCount
    }

    func capturedSubdivisionURL() -> String? {
        lastSubdivisionURL
    }

    func fetchStateSubdivision(from URLString: String) async throws -> StateSubdivision {
        fetchStateSubdivisionCallCount += 1
        lastSubdivisionURL = URLString
        switch stateSubdivisionResult {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    func fetchRoot() async throws -> Index { fatalError("Unused in this test") }
    func fetchCountry(from URLString: String) async throws -> Country { fatalError("Unused in this test") }
    func fetchState(from URLString: String) async throws -> StateDetails { fatalError("Unused in this test") }
    func fetchSigns(type: SearchType) async throws -> [RoadSign] { fatalError("Unused in this test") }
    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails { fatalError("Unused in this test") }
}

private enum MockError: Error {
    case generic
}

import XCTest
@testable import rpbrowser

@MainActor
final class RoadSignsViewModelTests: XCTestCase {
    func testFetchSignsLoadsSignsAndSearchTitleForTerm() async {
        let signs = [makeSign(state: "New York", place: "Albany", county: "Albany")]
        let service = MockSignSearchServiceForSigns(signsResult: .success(signs))
        let viewModel = RoadSignsViewModel(service: service)

        await viewModel.fetchSigns(searchType: .Term("stop"))

        XCTAssertEqual(viewModel.state, .loaded(RoadSignLoaded(signs: signs, title: "Search Results for stop")))
        let callCount = await service.callCount()
        let searchType = await service.capturedSearchType()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(searchType, .Term("stop"))
    }

    func testFetchSignsUsesNoResultsTitleWhenEmpty() async {
        let service = MockSignSearchServiceForSigns(signsResult: .success([]))
        let viewModel = RoadSignsViewModel(service: service)

        await viewModel.fetchSigns(searchType: .StateFilter("ny"))

        XCTAssertEqual(viewModel.state, .loaded(RoadSignLoaded(signs: [], title: "No Results Found")))
    }

    func testFetchSignsSetsErrorStateForApiError() async {
        let service = MockSignSearchServiceForSigns(signsResult: .failure(APIError.invalidResponse))
        let viewModel = RoadSignsViewModel(service: service)

        await viewModel.fetchSigns(searchType: .Term("yield"))

        XCTAssertEqual(viewModel.state, .error("Invalid response from server"))
    }

    func testGetSearchTitleReturnsExpectedStrings() {
        let viewModel = RoadSignsViewModel(service: MockSignSearchServiceForSigns(signsResult: .success([])))
        let sign = makeSign(state: "Massachusetts", place: "Boston", county: "Suffolk")

        XCTAssertEqual(viewModel.getSearchTitle(searchType: .StateFilter("ma"), sign: sign), "Signs from Massachusetts")
        XCTAssertEqual(viewModel.getSearchTitle(searchType: .PlaceFilter("ma_boston"), sign: sign), "Signs from Boston, Massachusetts")
        XCTAssertEqual(viewModel.getSearchTitle(searchType: .StateSubdivisionFilter("ma_suffolk"), sign: sign), "Signs from Suffolk, Massachusetts")
        XCTAssertEqual(viewModel.getSearchTitle(searchType: .Location(Coordinates(latitude: 1, longitude: 2)), sign: sign), "Signs at Current Location")
    }

    private func makeSign(state: String, place: String, county: String) -> RoadSign {
        RoadSign(
            id: "id-1",
            latitude: 1,
            longitude: 2,
            country: "US",
            countrySlug: "us",
            county: county,
            countySlug: "county",
            place: place,
            placeSlug: "place",
            state: state,
            stateSlug: "state",
            dateTaken: "2024-01-01",
            description: "desc",
            quality: 80,
            title: "Title",
            highways: [Highway(id: "h1", name: "Highway 1")],
            url: "https://example.com/photo_l.jpg"
        )
    }
}

private actor MockSignSearchServiceForSigns: SignSearchService {
    private let signsResult: Result<[RoadSign], Error>

    private(set) var fetchSignsCallCount = 0
    private(set) var lastSearchType: SearchType?

    init(signsResult: Result<[RoadSign], Error>) {
        self.signsResult = signsResult
    }

    func callCount() -> Int {
        fetchSignsCallCount
    }

    func capturedSearchType() -> SearchType? {
        lastSearchType
    }

    func fetchSigns(type: SearchType) async throws -> [RoadSign] {
        fetchSignsCallCount += 1
        lastSearchType = type
        switch signsResult {
        case .success(let signs):
            return signs
        case .failure(let error):
            throw error
        }
    }

    func fetchRoot() async throws -> Index { fatalError("Unused in this test") }
    func fetchCountry(from URLString: String) async throws -> Country { fatalError("Unused in this test") }
    func fetchState(from URLString: String) async throws -> StateDetails { fatalError("Unused in this test") }
    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails { fatalError("Unused in this test") }
    func fetchStateSubdivision(from URLString: String) async throws -> StateSubdivision { fatalError("Unused in this test") }
}

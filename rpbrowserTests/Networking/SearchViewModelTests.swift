import XCTest
@testable import rpbrowser

@MainActor
final class SearchViewModelTests: XCTestCase {
    func testFetchSignsWithEmptyTermSetsIdleState() async {
        let service = MockSignSearchService()
        let viewModel = SearchViewModel(service: service)

        await viewModel.fetchSigns(for: "")

        XCTAssertEqual(viewModel.state, .idle)
        let callCount = await service.signsCallCount()
        XCTAssertEqual(callCount, 0)
    }

    func testFetchSignsLoadsSignsOnSuccess() async {
        let signs = [makeSign(state: "California", place: "Los Angeles", county: "Los Angeles")]
        let service = MockSignSearchService(signsResult: .success(signs))
        let viewModel = SearchViewModel(service: service)

        await viewModel.fetchSigns(for: "stop")

        XCTAssertEqual(viewModel.state, .loaded(signs))
        let callCount = await service.signsCallCount()
        let searchType = await service.lastSignsSearchTypeCalled()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(searchType, .Term("stop"))
    }

    func testFetchSignsSetsErrorStateForApiError() async {
        let service = MockSignSearchService(signsResult: .failure(APIError.invalidResponse))
        let viewModel = SearchViewModel(service: service)

        await viewModel.fetchSigns(for: "yield")

        XCTAssertEqual(viewModel.state, .error("Invalid response from server"))
    }

    func testFetchSignsSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(signsResult: .failure(MockError.generic))
        let viewModel = SearchViewModel(service: service)

        await viewModel.fetchSigns(for: "stop")

        XCTAssertEqual(viewModel.state, .error("unknown error"))
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

private enum MockError: Error {
    case generic
}

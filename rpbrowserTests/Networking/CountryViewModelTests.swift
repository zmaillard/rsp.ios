import XCTest
@testable import rpbrowser

@MainActor
final class CountryViewModelTests: XCTestCase {
    func testFetchLoadsCountriesOnSuccess() async {
        let expected = makeIndex()
        let service = MockSignSearchService(rootResult: .success(expected))
        let viewModel = CountryViewModel(service: service)

        await viewModel.fetch()

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.rootCallCount()
        XCTAssertEqual(callCount, 1)
    }

    func testFetchSetsErrorStateForApiError() async {
        let service = MockSignSearchService(rootResult: .failure(APIError.invalidResponse))
        let viewModel = CountryViewModel(service: service)

        await viewModel.fetch()

        XCTAssertEqual(viewModel.state, .error("Invalid response from server"))
    }

    func testFetchSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(rootResult: .failure(MockError.generic))
        let viewModel = CountryViewModel(service: service)

        await viewModel.fetch()

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchDoesNotStartSecondRequestWhileLoading() async {
        let service = MockSignSearchService(rootResult: .success(makeIndex()))
        let viewModel = CountryViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetch()

        let callCount = await service.rootCallCount()
        XCTAssertEqual(callCount, 0)
        XCTAssertEqual(viewModel.state, .loading)
    }

    func testFetchAllowsRefetchAfterError() async {
        let expected = makeIndex()
        let service = MockSignSearchService(rootResult: .success(expected))
        let viewModel = CountryViewModel(service: service)
        viewModel.state = .error("previous error")

        await viewModel.fetch()

        let callCount = await service.rootCallCount()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(viewModel.state, .loaded(expected))
    }

    private func makeIndex() -> Index {
        Index(imageCount: 5000, countries: [
            CountrySlim(
                id: "us",
                name: "United States",
                subdivisionName: "State",
                url: "https://example.com/us.json",
                imageCount: 5000,
                states: [],
                featured: nil
            )
        ])
    }
}

private enum MockError: Error {
    case generic
}

import XCTest
@testable import rpbrowser

@MainActor
final class CountryDetailsViewModelTests: XCTestCase {
    func testFetchLoadsCountryDetailsOnSuccess() async {
        let expected = makeCountry()
        let service = MockSignSearchService(countryResult: .success(expected))
        let viewModel = CountryDetailsViewModel(service: service)

        await viewModel.fetch(for: makeCountrySlim())

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.countryCallCount()
        let lastURL = await service.lastCountryURLCalled()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(lastURL, "https://example.com/country.json")
    }

    func testFetchSetsErrorStateForApiError() async {
        let service = MockSignSearchService(countryResult: .failure(APIError.invalidURL))
        let viewModel = CountryDetailsViewModel(service: service)

        await viewModel.fetch(for: makeCountrySlim())

        XCTAssertEqual(viewModel.state, .error("The URL is Invalid"))
    }

    func testFetchSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(countryResult: .failure(MockError.generic))
        let viewModel = CountryDetailsViewModel(service: service)

        await viewModel.fetch(for: makeCountrySlim())

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchDoesNotStartSecondRequestWhileLoading() async {
        let service = MockSignSearchService(countryResult: .success(makeCountry()))
        let viewModel = CountryDetailsViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetch(for: makeCountrySlim())

        let callCount = await service.countryCallCount()
        XCTAssertEqual(callCount, 0)
        XCTAssertEqual(viewModel.state, .loading)
    }

    private func makeCountrySlim() -> CountrySlim {
        CountrySlim(
            id: "us",
            name: "United States",
            subdivisionName: "State",
            url: "https://example.com/country.json",
            imageCount: 1000,
            states: [],
            featured: nil
        )
    }

    private func makeCountry() -> Country {
        Country(
            id: "us",
            name: "United States",
            imageCount: 1000,
            states: [
                StateSlim(
                    id: "ny",
                    name: "New York",
                    url: "https://example.com/state.json",
                    imageCount: 50,
                    featured: nil
                )
            ],
            highwayTypes: [],
            subdivisionName: "State"
        )
    }
}

private enum MockError: Error {
    case generic
}

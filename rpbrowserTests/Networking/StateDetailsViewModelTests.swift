import XCTest
@testable import rpbrowser

@MainActor
final class StateDetailsViewModelTests: XCTestCase {
    func testFetchLoadsStateDetailsOnSuccess() async {
        let expected = makeStateDetails()
        let service = MockSignSearchService(stateResult: .success(expected))
        let viewModel = StateDetailsViewModel(service: service)

        await viewModel.fetch(for: makeStateSlim())

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.stateCallCount()
        let lastURL = await service.lastStateURLCalled()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(lastURL, "https://example.com/state.json")
    }

    func testFetchSetsErrorStateForApiError() async {
        let service = MockSignSearchService(stateResult: .failure(APIError.invalidURL))
        let viewModel = StateDetailsViewModel(service: service)

        await viewModel.fetch(for: makeStateSlim())

        XCTAssertEqual(viewModel.state, .error("The URL is Invalid"))
    }

    func testFetchSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(stateResult: .failure(MockError.generic))
        let viewModel = StateDetailsViewModel(service: service)

        await viewModel.fetch(for: makeStateSlim())

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchDoesNotStartSecondRequestWhileLoading() async {
        let service = MockSignSearchService(stateResult: .success(makeStateDetails()))
        let viewModel = StateDetailsViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetch(for: makeStateSlim())

        let callCount = await service.stateCallCount()
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

private enum MockError: Error {
    case generic
}

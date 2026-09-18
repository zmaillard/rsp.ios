import XCTest
@testable import rpbrowser

@MainActor
final class RoadSignListViewModelTests: XCTestCase {
    func testFetchSignsLoadsSubdivisionOnSuccess() async {
        let expected = makeSubdivision()
        let service = MockSignSearchService(stateSubdivisionResult: .success(expected))
        let viewModel = RoadSignListViewModel(service: service)

        await viewModel.fetchSigns(url: "https://example.com/subdivision.json")

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.stateSubdivisionCallCount()
        let lastURL = await service.lastSubdivisionURLCalled()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(lastURL, "https://example.com/subdivision.json")
    }

    func testFetchSignsSetsErrorStateForApiError() async {
        let service = MockSignSearchService(stateSubdivisionResult: .failure(APIError.invalidURL))
        let viewModel = RoadSignListViewModel(service: service)

        await viewModel.fetchSigns(url: "bad-url")

        XCTAssertEqual(viewModel.state, .error("The URL is Invalid"))
    }

    func testFetchSignsSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(stateSubdivisionResult: .failure(MockError.generic))
        let viewModel = RoadSignListViewModel(service: service)

        await viewModel.fetchSigns(url: "https://example.com/subdivision.json")

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchSignsDoesNotStartSecondRequestWhileLoading() async {
        let service = MockSignSearchService(stateSubdivisionResult: .success(makeSubdivision()))
        let viewModel = RoadSignListViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetchSigns(url: "https://example.com/subdivision.json")

        let callCount = await service.stateSubdivisionCallCount()
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

private enum MockError: Error {
    case generic
}

import XCTest
@testable import rpbrowser

@MainActor
final class RandomViewModelTests: XCTestCase {
    func testFetchLoadsRandomSignDetailsOnSuccess() async {
        let expected = makeSignDetails()
        let service = MockSignSearchService(signDetailResult: .success(expected))
        let viewModel = RandomViewModel(service: service)

        await viewModel.fetch(count: 100)

        XCTAssertEqual(viewModel.state, .loaded(expected))
        let callCount = await service.signDetailCallCount()
        XCTAssertEqual(callCount, 1)
    }

    func testFetchSetsErrorStateForApiError() async {
        let service = MockSignSearchService(signDetailResult: .failure(APIError.invalidResponse))
        let viewModel = RandomViewModel(service: service)

        await viewModel.fetch(count: 100)

        XCTAssertEqual(viewModel.state, .error("Invalid response from server"))
    }

    func testFetchSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(signDetailResult: .failure(MockError.generic))
        let viewModel = RandomViewModel(service: service)

        await viewModel.fetch(count: 100)

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchWithZeroCountDoesNotFetch() async {
        let service = MockSignSearchService(signDetailResult: .success(makeSignDetails()))
        let viewModel = RandomViewModel(service: service)

        await viewModel.fetch(count: 0)

        let callCount = await service.signDetailCallCount()
        XCTAssertEqual(callCount, 0)
        XCTAssertEqual(viewModel.state, .idle)
    }

    func testFetchDoesNotStartNewRequestWhileLoading() async {
        let service = MockSignSearchService(signDetailResult: .success(makeSignDetails()))
        let viewModel = RandomViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetch(count: 100)

        let callCount = await service.signDetailCallCount()
        XCTAssertEqual(callCount, 0)
        XCTAssertEqual(viewModel.state, .loading)
    }

    func testFetchFetchesNewRandomSignWhenAlreadyLoaded() async {
        let firstSign = makeSignDetails()
        let secondSign = makeSignDetails()
        let service = MockSignSearchService(signDetailResult: .success(secondSign))
        let viewModel = RandomViewModel(service: service)
        viewModel.state = .loaded(firstSign)

        await viewModel.fetch(count: 100)

        let callCount = await service.signDetailCallCount()
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(viewModel.state, .loaded(secondSign))
    }

    private func makeSignDetails() -> RoadSignDetails {
        RoadSignDetails.example
    }
}

private enum MockError: Error {
    case generic
}

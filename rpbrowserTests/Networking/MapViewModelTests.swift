import XCTest
@testable import rpbrowser

@MainActor
final class MapViewModelTests: XCTestCase {
    func testFetchSignsLoadsSingsForBoundingBoxOnSuccess() async {
        let signs = [makeSign(state: "California", place: "San Francisco", county: "San Francisco")]
        let service = MockSignSearchService(signsResult: .success(signs))
        let viewModel = MapViewModel(service: service)
        let location = Rectangle(
            lowerLeft: Coordinates(latitude: 37.7, longitude: -122.5),
            upperRight: Coordinates(latitude: 37.8, longitude: -122.4)
        )

        await viewModel.fetchSigns(for: location)

        XCTAssertEqual(viewModel.state, .loaded(signs))
        let callCount = await service.signsCallCount()
        let searchType = await service.lastSignsSearchTypeCalled()
        XCTAssertEqual(callCount, 1)
        
        if case .BoundingBox(let lowerLeft, let upperRight) = searchType {
            XCTAssertEqual(lowerLeft, location.lowerLeft)
            XCTAssertEqual(upperRight, location.upperRight)
        } else {
            XCTFail("Expected BoundingBox search type")
        }
    }

    func testFetchSignsSetsErrorStateForApiError() async {
        let service = MockSignSearchService(signsResult: .failure(APIError.invalidResponse))
        let viewModel = MapViewModel(service: service)
        let location = Rectangle(
            lowerLeft: Coordinates(latitude: 37.7, longitude: -122.5),
            upperRight: Coordinates(latitude: 37.8, longitude: -122.4)
        )

        await viewModel.fetchSigns(for: location)

        XCTAssertEqual(viewModel.state, .error("Invalid response from server"))
    }

    func testFetchSignsSetsUnknownErrorForNonApiError() async {
        let service = MockSignSearchService(signsResult: .failure(MockError.generic))
        let viewModel = MapViewModel(service: service)
        let location = Rectangle(
            lowerLeft: Coordinates(latitude: 37.7, longitude: -122.5),
            upperRight: Coordinates(latitude: 37.8, longitude: -122.4)
        )

        await viewModel.fetchSigns(for: location)

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    private func makeSign(state: String, place: String, county: String) -> RoadSign {
        RoadSign(
            id: "id-1",
            latitude: 37.7,
            longitude: -122.4,
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

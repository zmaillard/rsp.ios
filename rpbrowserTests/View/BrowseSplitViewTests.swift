import XCTest
@testable import rpbrowser

@MainActor
final class BrowseSplitViewTests: XCTestCase {
    func testHandleSelectionChangeFetchesStateSubdivisionForBrowseURL() async {
        let listService = TestSignSearchService(
            stateSubdivisionResult: .success(makeSubdivision())
        )
        let signsService = TestSignSearchService(
            signsResult: .success([makeSign(id: "id-1")])
        )

        let sut = makeView(listService: listService, signsService: signsService)

        await sut.handleSelectionChange(.browseUrl("Albany, New York", "https://example.com/subdivision.json"))

        let listCalls = await listService.stateSubdivisionCallCount()
        let signsCalls = await signsService.signsCallCount()
        XCTAssertEqual(listCalls, 1)
        XCTAssertEqual(signsCalls, 0)
    }

    func testHandleSelectionChangeFetchesSignsForBrowseSearch() async {
        let listService = TestSignSearchService(
            stateSubdivisionResult: .success(makeSubdivision())
        )
        let signsService = TestSignSearchService(
            signsResult: .success([makeSign(id: "id-1")])
        )

        let sut = makeView(listService: listService, signsService: signsService)

        await sut.handleSelectionChange(.browseSearch(.Term("stop")))

        let listCalls = await listService.stateSubdivisionCallCount()
        let signsCalls = await signsService.signsCallCount()
        XCTAssertEqual(listCalls, 0)
        XCTAssertEqual(signsCalls, 1)
    }

    func testHandleSelectionChangeWithNoSelectionDoesNotFetch() async {
        let listService = TestSignSearchService(
            stateSubdivisionResult: .success(makeSubdivision())
        )
        let signsService = TestSignSearchService(
            signsResult: .success([makeSign(id: "id-1")])
        )

        let sut = makeView(listService: listService, signsService: signsService)

        await sut.handleSelectionChange(nil)

        let listCalls = await listService.stateSubdivisionCallCount()
        let signsCalls = await signsService.signsCallCount()
        XCTAssertEqual(listCalls, 0)
        XCTAssertEqual(signsCalls, 0)
    }

    private func makeView(listService: TestSignSearchService, signsService: TestSignSearchService) -> BrowseSplitView {
        BrowseSplitView(
            state: makeStateSlim(),
            stateDetailsViewModel: StateDetailsViewModel(service: TestSignSearchService(stateResult: .success(makeStateDetails()))),
            roadSignListViewModel: RoadSignListViewModel(service: listService),
            roadSignsViewModel: RoadSignsViewModel(service: signsService)
        )
    }

    private func makeStateSlim() -> StateSlim {
        StateSlim(
            id: "ny",
            name: "New York",
            url: "https://example.com/state.json",
            imageCount: 1,
            featured: nil
        )
    }

    private func makeStateDetails() -> StateDetails {
        StateDetails(
            id: "ny",
            highways: [],
            name: "New York",
            imageCount: 1,
            places: [],
            stateSubdivisions: [],
            subdivisionName: "Counties"
        )
    }

    private func makeSubdivision() -> StateSubdivision {
        StateSubdivision(
            id: "albany",
            name: "Albany County",
            stateSlug: "ny",
            imageCount: 1,
            signs: [
                RoadSignSlim(
                    id: "img-1",
                    title: "Stop",
                    image: "https://example.com/image.jpg",
                    url: "https://example.com/sign.json"
                )
            ]
        )
    }

    private func makeSign(id: String) -> RoadSign {
        RoadSign(
            id: id,
            latitude: 1,
            longitude: 2,
            country: "US",
            countrySlug: "us",
            county: "Albany",
            countySlug: "albany",
            place: "Albany",
            placeSlug: "albany",
            state: "New York",
            stateSlug: "ny",
            dateTaken: "2024-01-01",
            description: "desc",
            quality: 90,
            title: "Stop",
            highways: [],
            url: "https://example.com/photo_l.jpg"
        )
    }
}

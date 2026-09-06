import XCTest
import SwiftUI
@testable import rpbrowser

@MainActor
final class StateGridViewTests: XCTestCase {
    func testRendersWhenFeaturedImageExists() {
        let view = StateGridView(state: makeState(featured: ImageDetails.example))
        let host = UIHostingController(rootView: view)

        host.loadViewIfNeeded()

        XCTAssertNotNil(host.view)
    }

    func testRendersWhenFeaturedImageIsMissing() {
        let view = StateGridView(state: makeState(featured: nil))
        let host = UIHostingController(rootView: view)

        host.loadViewIfNeeded()

        XCTAssertNotNil(host.view)
    }

    private func makeState(featured: ImageDetails?) -> StateSlim {
        StateSlim(
            id: "ny",
            name: "New York",
            url: "https://example.com/state.json",
            imageCount: 42,
            featured: featured
        )
    }
}

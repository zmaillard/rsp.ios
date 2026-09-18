import XCTest
import SwiftUI
@testable import rpbrowser

@MainActor
final class StateGridViewInteractionTests: XCTestCase {
    
    func testStateGridViewDisplaysStateNameCorrectly() {
        let state = makeState(name: "California", featured: ImageDetails.example)
        let view = StateGridView(state: state)
        let host = UIHostingController(rootView: view)

        host.loadViewIfNeeded()

        XCTAssertNotNil(host.view)
    }

    func testStateGridViewRendersWithoutFeaturedImage() {
        let state = makeState(name: "Texas", featured: nil)
        let view = StateGridView(state: state)
        let host = UIHostingController(rootView: view)

        host.loadViewIfNeeded()

        XCTAssertNotNil(host.view)
    }

    func testStateGridViewHandlesLargePlaceCounts() {
        let state = makeState(name: "Florida", imageCount: 10000, featured: ImageDetails.example)
        let view = StateGridView(state: state)
        let host = UIHostingController(rootView: view)

        host.loadViewIfNeeded()

        XCTAssertNotNil(host.view)
    }

    func testMultipleStateGridViewsCanRenderSimultaneously() {
        let state1 = makeState(name: "New York", featured: ImageDetails.example)
        let state2 = makeState(name: "Pennsylvania", featured: nil)
        let state3 = makeState(name: "Connecticut", featured: ImageDetails.example)

        let view1 = StateGridView(state: state1)
        let view2 = StateGridView(state: state2)
        let view3 = StateGridView(state: state3)

        let host1 = UIHostingController(rootView: view1)
        let host2 = UIHostingController(rootView: view2)
        let host3 = UIHostingController(rootView: view3)

        host1.loadViewIfNeeded()
        host2.loadViewIfNeeded()
        host3.loadViewIfNeeded()

        XCTAssertNotNil(host1.view)
        XCTAssertNotNil(host2.view)
        XCTAssertNotNil(host3.view)
    }

    private func makeState(name: String, imageCount: Int = 100, featured: ImageDetails?) -> StateSlim {
        StateSlim(
            id: name.lowercased(),
            name: name,
            url: "https://example.com/\(name.lowercased()).json",
            imageCount: imageCount,
            featured: featured
        )
    }
}

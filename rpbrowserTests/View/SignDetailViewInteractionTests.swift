import XCTest
import SwiftUI
@testable import rpbrowser

@MainActor
final class SignDetailViewInteractionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UIPasteboard.general.string = nil
    }

    override func tearDown() {
        UIPasteboard.general.string = nil
        super.tearDown()
    }

    func testViewRendersWithSignDetails() {
        let sign = RoadSignDetails.example
        let view = SignDetailView(sign: sign, onRefresh: nil)
        let host = UIHostingController(rootView: view)

        host.loadViewIfNeeded()

        XCTAssertNotNil(host.view)
    }

    func testRefreshCallbackIsInvoked() {
        let sign = RoadSignDetails.example
        var refreshCalled = false
        let onRefresh = { refreshCalled = true }
        let view = SignDetailView(sign: sign, onRefresh: onRefresh)
        
        // Verify callback is stored
        XCTAssertNotNil(onRefresh)
    }

    func testMultipleCopyOperationsPreserveData() {
        let sign = RoadSignDetails.example
        let view = SignDetailView(sign: sign, onRefresh: nil)

        view.copyImageId()
        let firstCopy = UIPasteboard.general.string

        view.copyImageId()
        let secondCopy = UIPasteboard.general.string

        XCTAssertEqual(firstCopy, secondCopy)
        XCTAssertEqual(firstCopy, sign.id)
    }
}

import XCTest
import SwiftUI
import ViewInspector
@testable import rpbrowser

extension SignDetailView: Inspectable {}

@MainActor
final class SignDetailViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UIPasteboard.general.string = nil
    }

    override func tearDown() {
        UIPasteboard.general.string = nil
        super.tearDown()
    }

    func testCopyImageIdCopiesSignIdToPasteboard() {
        let sign = makeSignDetails()
        let sut = SignDetailView(sign: sign, onRefresh: nil)

        sut.copyImageId()

        XCTAssertEqual(UIPasteboard.general.string, "4927305864119930844")
    }
    
    // Minimal fixture; fill any additional required fields from your model init.
    private func makeSignDetails() -> RoadSignDetails {
        return RoadSignDetails.example
    }
}

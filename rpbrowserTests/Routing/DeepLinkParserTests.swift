import XCTest
@testable import rpbrowser

@MainActor
final class DeepLinkParserTests: XCTestCase {
    func testParseReturnsNilForWrongScheme() {
        let url = URL(string: "https://rpbrowser/show-sign/abc")!

        let route = DeepLinkParser.Parse(url)

        XCTAssertNil(route)
    }

    func testParseReturnsSignRouteForShowSignHost() {
        let url = URL(string: "rpbrowser://show-sign/abc123")!

        let route = DeepLinkParser.Parse(url)

        XCTAssertEqual(route, [.sign("abc123")])
    }

    func testParseReturnsNilWhenShowSignPathComponentMissing() {
        let url = URL(string: "rpbrowser://show-sign")!

        let route = DeepLinkParser.Parse(url)

        XCTAssertNil(route)
    }

    func testParseReturnsNilForUnknownHost() {
        let url = URL(string: "rpbrowser://not-supported/abc123")!

        let route = DeepLinkParser.Parse(url)

        XCTAssertNil(route)
    }
}

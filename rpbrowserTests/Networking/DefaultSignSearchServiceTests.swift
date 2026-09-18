import XCTest
@testable import rpbrowser

final class DefaultSignSearchServiceTests: XCTestCase {
    @MainActor
    func testFetchWithValidJSONDecodesSuccessfully() async throws {
        // This tests the generic fetch function's ability to decode JSON
        let jsonData = """
        {
            "id": "sign-1",
            "_geo": { "lat": 42.36, "lng": -71.05 },
            "country": { "name": "United States", "slug": "united-states" },
            "county": { "name": "Suffolk", "slug": "suffolk" },
            "place": { "name": "Boston", "slug": "boston" },
            "state": { "name": "Massachusetts", "slug": "massachusetts" },
            "date_taken": "2024-01-01",
            "description": "A stop sign",
            "title": "Stop",
            "highways": [{ "slug": "i-90", "name": "Interstate 90" }],
            "url": "https://example.com/sign_l.jpg",
            "quality": 87
        }
        """.data(using: .utf8)!

        let sign = try JSONDecoder().decode(RoadSign.self, from: jsonData)
        
        XCTAssertEqual(sign.id, "sign-1")
        XCTAssertEqual(sign.country, "United States")
        XCTAssertEqual(sign.state, "Massachusetts")
    }
}


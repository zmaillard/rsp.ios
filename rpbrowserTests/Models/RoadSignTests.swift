import XCTest
@testable import rpbrowser

@MainActor
final class RoadSignTests: XCTestCase {
    func testDecodeRoadSignParsesNestedFields() throws {
        let json = """
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

        let sign = try JSONDecoder().decode(RoadSign.self, from: json)

        XCTAssertEqual(sign.id, "sign-1")
        XCTAssertEqual(sign.latitude, 42.36, accuracy: 0.0001)
        XCTAssertEqual(sign.longitude, -71.05, accuracy: 0.0001)
        XCTAssertEqual(sign.country, "United States")
        XCTAssertEqual(sign.countrySlug, "united-states")
        XCTAssertEqual(sign.county, "Suffolk")
        XCTAssertEqual(sign.placeSlug, "boston")
        XCTAssertEqual(sign.state, "Massachusetts")
        XCTAssertEqual(sign.highways, [Highway(id: "i-90", name: "Interstate 90")])
    }

    func testGetImageUrlConvertsLargeImageUrlToSmallVariant() {
        let sign = makeSign(url: "https://example.com/photo_l.jpg")

        XCTAssertEqual(sign.getImageUrl(), "https://example.com/photo_s.jpg")
    }

    func testRoadSignEquatableMatchesAllFields() {
        let lhs = makeSign(url: "https://example.com/a_l.jpg")
        let rhs = makeSign(url: "https://example.com/a_l.jpg")
        let different = makeSign(url: "https://example.com/b_l.jpg")

        XCTAssertEqual(lhs, rhs)
        XCTAssertNotEqual(lhs, different)
    }

    private func makeSign(url: String) -> RoadSign {
        RoadSign(
            id: "id-1",
            latitude: 1,
            longitude: 2,
            country: "US",
            countrySlug: "us",
            county: "County",
            countySlug: "county",
            place: "Place",
            placeSlug: "place",
            state: "State",
            stateSlug: "state",
            dateTaken: "2024-01-01",
            description: "desc",
            quality: 1,
            title: "title",
            highways: [Highway(id: "h1", name: "Highway 1")],
            url: url
        )
    }
}

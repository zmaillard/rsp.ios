//
//  RoadSignDetails.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/11/26.
//
struct ImageDetails : Codable, Equatable, Hashable {
    let large: String
    let medium: String
    let original: String
    let small: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case original
        case small
        case thumbnail
    }
    // MARK: - Preview
    static var example: ImageDetails {
        let base = "https://sign.roadsign.pictures/5090401834372614470/5090401834372614470"
        
        return ImageDetails(large: "\(base)_l.jpg", medium: "\(base)_m.jpg", original: "\(base).jpg", small: "\(base)_s.jpg", thumbnail: "\(base)_t.jpg")
        
    }
}

struct RoadSignDetails : Decodable, Identifiable, Equatable, Hashable, SignRowRecord {
    let id: String
    let date: String
    let description: String
    let hasProcessed: Bool
    let highways: [HighwaySlim]
    let image: ImageDetails
    let latitude: Double
    let longitude: Double
    let place: PlaceSlim?
    let state: StateSlim
    let country: CountrySlim
    let stateSubdivision: StateSubdivisionSlim?
    let title: String
    
    func getImageUrl() -> String {
        return image.medium
    }
    
    
    enum CodingKeys: String, CodingKey {
        case date
        case description
        case hasProcessed
        case highways
        case id = "imageid"
        case image
        case latitude
        case longitude
        case state
        case stateSubdivision
        case place
        case title
        case country
    }
    
    func ToRoadSign() -> RoadSign {
        return RoadSign(id: self.id, latitude: self.latitude, longitude: self.longitude, country: self.country.name, countrySlug: self.country.id, county: self.stateSubdivision?.name ?? "", countySlug: self.stateSubdivision?.id ?? "", place: self.place?.name ?? "", placeSlug: self.place?.id ?? "", state: self.state.name, stateSlug: self.state.id, dateTaken: self.date, description: self.description, quality: 0, title: self.title, highways: self.highways.map { Highway(id: $0.id, name: $0.name) }, url: self.image.large)
    }
    
    // MARK: - Preview
    static var example: RoadSignDetails {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return RoadSignDetails(id: "", date: "", description: "", hasProcessed: false, highways: [], image: ImageDetails(large: "", medium: "", original: "", small: "", thumbnail: ""), latitude: 0.0, longitude: 0.0, place: nil, state: StateSlim(id: "", name: "", url: "", imageCount: 10, featured: nil), country: CountrySlim(id: "", name: "", subdivisionName: "", url: "", imageCount: 10, states: [], featured: ImageDetails.example), stateSubdivision: nil, title: "")
        }
        
        return sampleData.sign
    }
    
}

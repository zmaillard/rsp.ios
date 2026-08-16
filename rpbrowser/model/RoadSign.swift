//
//  RoadSign.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//


import Foundation

struct RoadSign: Decodable, Hashable, CustomStringConvertible, Identifiable, Equatable {
    let id: String
    let latitude: Double
    let longitude: Double
    let country: String
    let countrySlug: String
    let county: String
    let countySlug: String
    let place: String
    let placeSlug: String
    let state: String
    let stateSlug: String
    let dateTaken: String
    let description: String
    let quality: Int
    let title: String
    let highways: [Highway]
    let url: String
    
    enum GeoKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    
    enum LocationKeys: String, CodingKey {
        case name
        case slug
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case geo = "_geo"
        case country
        case county
        case place
        case state
        case dateTaken = "date_taken"
        case description
        case title
        case highways
        case url
        case quality
    }
    
    init (id: String, latitude: Double, longitude: Double, country: String, countrySlug: String, county: String, countySlug: String, place: String, placeSlug: String, state: String, stateSlug: String, dateTaken: String, description: String, quality: Int, title: String, highways: [Highway], url: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.countrySlug = countrySlug
        self.county = county
        self.countySlug = countySlug
        self.place = place
        self.placeSlug = placeSlug
        self.state = state
        self.stateSlug = stateSlug
        self.dateTaken = dateTaken
        self.description = description
        self.quality = quality
        self.title = title
        self.highways = highways
        self.url = url
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let geoContainer = try container.nestedContainer(keyedBy: GeoKeys.self, forKey: .geo)
        let placeContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .place)
        let stateContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .state)
        let countyContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .county)
        let countryContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        
        
        self.id = try container.decode(String.self, forKey: .id)
        self.latitude = try geoContainer.decode(Double.self, forKey: .latitude)
        self.longitude = try geoContainer.decode(Double.self, forKey: .longitude)
        self.country = try countryContainer.decode(String.self, forKey: .name)
        self.countrySlug = try countryContainer.decode(String.self, forKey: .slug)
        self.place = try placeContainer.decode(String.self, forKey: .name)
        self.placeSlug = try placeContainer.decode(String.self, forKey: .slug)
        self.state = try stateContainer.decode(String.self, forKey: .name)
        self.stateSlug = try stateContainer.decode(String.self, forKey: .slug)
        self.county = try countyContainer.decode(String.self, forKey: .name)
        self.countySlug = try countyContainer.decode(String.self, forKey: .slug)
        self.dateTaken = try container.decode(String.self, forKey: .dateTaken)
        self.description = try container.decode(String.self, forKey: .description)
        self.title = try container.decode(String.self, forKey: .title)
        self.highways = try container.decode([Highway].self, forKey: .highways)
        self.url = try container.decode(String.self, forKey: .url)
        self.quality = try container.decode(Int.self, forKey: .quality)
    }
    
    // MARK: - Preview
    static var example: RoadSign {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return RoadSign(id: "", latitude: 0.0, longitude: 0.0, country: "", countrySlug: "", county: "", countySlug: "", place: "", placeSlug: "", state: "", stateSlug: "", dateTaken: "", description: "", quality: 0, title: "", highways: [], url: "")
        }
        
        return sampleData.sign.ToRoadSign()
    }

}


    

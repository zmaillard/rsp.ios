//
//  Site.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/8/26.
//

struct Index: Decodable, Equatable, Hashable  {
    let imageCount: Int
    let countries: [CountrySlim]
    enum CodingKeys: String, CodingKey {
        case imageCount
        case countries
    }
    
    // MARK: - Preview
    static var example: Index {
        return Index(imageCount: 19099, countries: [
            CountrySlim(id: "united-states", name: "United States", url: "https://roadsign.pictures/country/united-states/index.json"),
            CountrySlim(id: "canada", name: "Canada", url: "https://roadsign.pictures/country/canada/index.json"),
            CountrySlim(id: "mexico", name: "Mexico", url: "https://roadsign.pictures/country/mexico/index.json"),
            CountrySlim(id: "costa-rica", name: "Costa Rica", url: "https://roadsign.pictures/country/costa-rica/index.json")
        ])
    }
}

struct CountrySlim: Codable, Comparable, Identifiable, Equatable, Hashable  {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
    static func < (lhs: CountrySlim, rhs: CountrySlim) -> Bool {
        return lhs.name < rhs.name
    }
    

    // MARK:: - Preview
    static var example: CountrySlim {
        return CountrySlim(id: "united-states", name: "United States", url: "https://roadsign.pictures/country/united-states/index.json")
    }

}

struct HighwayTypeSlim : Decodable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
}

struct StateSlim : Codable, Identifiable, Comparable, Equatable, Hashable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
    
    static func < (lhs: StateSlim, rhs: StateSlim) -> Bool {
        return lhs.name < rhs.name
    }
    

    
    // MARK: - Preview
    static var example: StateSlim {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return StateSlim(id: "", name: "", url: "")
        }
        
        return sampleData.country.states[0]
    }
}
struct Country : Decodable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let imageCount: Int
    let states: [StateSlim]
    let highwayTypes: [HighwayTypeSlim]
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case imageCount
        case states
        case highwayTypes
    }
    
    // MARK: - Preview
    static var example: Country {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return Country(id: "", name: "", imageCount: 0, states: [], highwayTypes: [])
        }
        
        return sampleData.country
    }
}

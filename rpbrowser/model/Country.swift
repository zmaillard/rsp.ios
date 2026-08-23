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
            CountrySlim(id: "united-states", name: "United States", subdivisionName: "State", url: "https://roadsign.pictures/country/united-states/index.json", imageCount: 10, states: [] ),
            CountrySlim(id: "canada", name: "Canada", subdivisionName: "Province", url: "https://roadsign.pictures/country/canada/index.json", imageCount: 10, states: [] ),
            CountrySlim(id: "mexico", name: "Mexico", subdivisionName: "Estado", url: "https://roadsign.pictures/country/mexico/index.json", imageCount: 10, states: [] ),
            CountrySlim(id: "costa-rica", name: "Costa Rica", subdivisionName: "Provincia", url: "https://roadsign.pictures/country/costa-rica/index.json",imageCount: 10, states: [] ),
        ])
    }
}


struct CountrySlim: Codable, Comparable, Identifiable, Equatable, Hashable  {
    let id: String
    let name: String
    let subdivisionName: String
    let url: String
    let imageCount: Int
    let states: [StateSlim]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case subdivisionName
        case url
        case imageCount
        case states
    }
    
    static func < (lhs: CountrySlim, rhs: CountrySlim) -> Bool {
        return lhs.name < rhs.name
    }
    

    // MARK:: - Preview
    static var example: CountrySlim {
        return CountrySlim(id: "united-states", name: "United States",subdivisionName: "State", url: "https://roadsign.pictures/country/united-states/index.json", imageCount: 10, states: [] )
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
    let imageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
        case imageCount
    }
    
    static func < (lhs: StateSlim, rhs: StateSlim) -> Bool {
        return lhs.name < rhs.name
    }
    

    
    // MARK: - Preview
    static var example: StateSlim {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return StateSlim(id: "", name: "", url: "", imageCount: 10)
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
    let subdivisionName: String

    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case imageCount
        case states
        case highwayTypes
        case subdivisionName
    }
    
    // MARK: - Preview
    static var example: Country {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return Country(id: "", name: "", imageCount: 0, states: [], highwayTypes: [], subdivisionName: "")
        }
        
        return sampleData.country
    }
}

//
//  State.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/8/26.
//
struct StateDetails : Equatable, Identifiable, Hashable, Decodable {
    let id: String
    let highways: [HighwaySlim]
    let name: String
    let imageCount: Int
    let places: [PlaceSlim]
    let stateSubdivisions: [StateSubdivisionSlim]
    let subdivisionName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case highways
        case name
        case imageCount
        case places
        case stateSubdivisions
        case subdivisionName
    }
    
    // MARK: - Preview
    static var example: StateDetails {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return StateDetails(id: "", highways: [], name: "", imageCount: 0, places: [], stateSubdivisions: [], subdivisionName: "")
        }
        
        return sampleData.state
    }
}

struct HighwaySlim : Equatable, Comparable, Identifiable, Hashable, Decodable {
    
    let id: String
    let imageName: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
        case imageName
    }
    static func < (lhs: HighwaySlim, rhs: HighwaySlim) -> Bool {
        return lhs.name < rhs.name
    }

}

struct StateSubdivisionSlim : Equatable, Comparable, Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
    
    static func < (lhs: StateSubdivisionSlim, rhs: StateSubdivisionSlim) -> Bool {
        return lhs.name < rhs.name
    }}

struct PlaceSlim : Equatable, Comparable, Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
    static func < (lhs: PlaceSlim, rhs: PlaceSlim) -> Bool {
        return lhs.name < rhs.name
    }
    
}

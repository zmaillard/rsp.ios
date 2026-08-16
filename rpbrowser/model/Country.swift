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
}

struct CountrySlim: Decodable,  Identifiable, Equatable, Hashable  {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
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

struct StateSlim : Decodable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
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
    
}

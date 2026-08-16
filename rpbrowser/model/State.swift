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
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case highways
        case name
        case imageCount
        case places
        case stateSubdivisions
    }
}

struct HighwaySlim : Equatable, Identifiable, Hashable, Decodable {
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
    
}

struct StateSubdivisionSlim : Equatable, Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
}

struct PlaceSlim : Equatable, Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case url
    }
}

//
//  Highway.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//


struct Highway: Codable, Hashable, CustomStringConvertible, Equatable {
    let id: String
    let name: String
    
    var description: String {
        return "\(name)"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case id = "slug"
    }
    
}

//
//  Results.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

struct SearchData: Decodable {
    let results: [Results]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([Results].self, forKey: .results)
    }
}

struct Results: Decodable {
    let index: String
    let hits: [RoadSign]
    
    
    enum CodingKeys: String, CodingKey {
        case hits
        case index = "indexUid"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(String.self, forKey: .index)
        self.hits = try container.decode([RoadSign].self, forKey: .hits)
    }
}

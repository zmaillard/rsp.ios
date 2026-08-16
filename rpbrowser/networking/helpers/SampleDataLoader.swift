//
//  SampleDataLoader.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/16/26.
//
import Foundation

struct SampleData : Decodable {
    let root: Index
    let search: [RoadSign]
    let country: Country
    let state: StateDetails
    let sign: RoadSignDetails
    
    enum CodingKeys: String, CodingKey {
        case root
        case search
        case country
        case state
        case sign = "signDetail"
        
    }
}

struct SampleDataLoader {
    
    static func loadSampleData() throws -> SampleData {
        guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
            throw APIError.invalidURL
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(SampleData.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decoding(error)
        } catch {
            throw APIError.networkError(error)
        }

    }
}

//
//  DefaultSignSearchService.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/6/26.
//
import Foundation

struct SampleData : Decodable {
    let root: Index
    let search: [RoadSign]
    let country: Country
    let state: StateDetails
    let sign: RoadSignDetails
}

struct MockSignSearchService : SignSearchService {
    
    
    private func loadSampleData() throws -> SampleData {
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
    
    func fetchSigns(type: SearchType) async throws -> [RoadSign] {
        let data = try loadSampleData()
        
        return data.search
    }
    func fetchRoot() async throws -> Index {
        let data = try loadSampleData()
        
        return data.root
    }

    func fetchCountry(from URLString: String) async throws -> Country{
        let data = try loadSampleData()
        
        return data.country
    }
    func fetchState(from URLString: String) async throws -> StateDetails {
        let data = try loadSampleData()
        
        return data.state
    }
    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails {
        let data = try loadSampleData()
        return data.sign

    }
}

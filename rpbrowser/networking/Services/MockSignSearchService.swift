//
//  DefaultSignSearchService.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/6/26.
//
import Foundation


struct MockSignSearchService : SignSearchService {
    
    
    
    func fetchSigns(type: SearchType) async throws -> [RoadSign] {
        let data = try SampleDataLoader.loadSampleData()
        
        return data.search
    }
    func fetchRoot() async throws -> Index {
        let data = try SampleDataLoader.loadSampleData()
        
        return data.root
    }

    func fetchCountry(from URLString: String) async throws -> Country{
        let data = try SampleDataLoader.loadSampleData()
        
        return data.country
    }
    func fetchState(from URLString: String) async throws -> StateDetails {
        let data = try SampleDataLoader.loadSampleData()
        
        return data.state
    }
    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails {
        let data = try SampleDataLoader.loadSampleData()
        return data.sign

    }
}

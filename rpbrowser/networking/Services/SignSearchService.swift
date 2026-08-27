//
//  SearchService.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/6/26.
//

protocol SignSearchService : Sendable{
    func fetchRoot() async throws -> Index
    func fetchCountry(from URLString: String) async throws -> Country
    func fetchState(from URLString: String) async throws -> StateDetails
    func fetchSigns(type: SearchType) async throws -> [RoadSign]
    func fetchSignDetail(from URLString: String) async throws -> RoadSignDetails
    func fetchStateSubdivision(from URLString: String) async throws -> StateSubdivision
}

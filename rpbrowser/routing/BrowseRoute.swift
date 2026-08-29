//
//  BrowseRoute.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/16/26.
//
enum BrowseRoute: Hashable, Codable {
    case stateDetails(StateSlim)
    case sign (String)
    case countylist(String, String)
    case placelist(String, String)
    case highwayList(SearchType)
}

enum MapRoute: Hashable, Codable {
    case sign (String)
}

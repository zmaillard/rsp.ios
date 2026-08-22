//
//  BrowseRoute.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/16/26.
//
enum BrowseRoute: Hashable, Codable {
    case state(CountrySlim)
    case stateDetails(StateSlim)
    case sign (String)
    case countylist(SearchType)
    case placelist(SearchType)
    case highwayList(SearchType)
}

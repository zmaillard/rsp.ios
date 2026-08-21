//
//  BrowseRoute.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/16/26.
//
enum BrowseRoute: Hashable {
    case state(CountrySlim)
    case stateDetails(StateSlim)
    case sign (RoadSign)
    case countylist(SearchType)
    case placelist(SearchType)
    case highwayList(SearchType)
    case signWithLoading(String)
}

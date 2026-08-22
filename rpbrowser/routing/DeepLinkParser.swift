//
//  DeepLinkParser.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/19/26.
//
import Foundation
struct DeepLinkParser {
    static func Parse(_ url: URL) ->  [BrowseRoute]? {
        guard url.scheme == "rpbrowser" else {
            return nil
        }
        
        let components = url.pathComponents.filter { $0 != "/" }
        switch url.host {
        case "show-sign-county":
            if components.count != 4 {
                return nil
            }
            
            let countrySlug = components[0]
            let stateSlug = components[1]
            let countySlug = components[2]
            let signId = components[3]
            
            
            
            return [BrowseRoute.state(CountrySlim(id: countrySlug, name: countrySlug, subdivisionName: "", url: "https://roadsign.pictures/country/\(countrySlug)/index.json")),
                    BrowseRoute.stateDetails(StateSlim(id: stateSlug, name: stateSlug, url: "https://roadsign.pictures/state/\(stateSlug)/index.json")),
                    BrowseRoute.countylist(SearchType.StateSubdivisionFilter(countySlug)),
                    BrowseRoute.sign(signId)]
        case "show-sign-place":
            if components.count != 4 {
                return nil
            }
            
            let countrySlug = components[0]
            let stateSlug = components[1]
            let placeSlug = components[2]
            let signId = components[3]
            
            
            
            return [BrowseRoute.state(CountrySlim(id: countrySlug, name: countrySlug, subdivisionName: "", url: "https://roadsign.pictures/country/\(countrySlug)/index.json")),
                    BrowseRoute.stateDetails(StateSlim(id: stateSlug, name: stateSlug, url: "https://roadsign.pictures/state/\(stateSlug)/index.json")),
                    BrowseRoute.placelist(SearchType.PlaceFilter(placeSlug)),
                    BrowseRoute.sign(signId)]
        case "show-sign-state":
            if components.count != 3 {
                return nil
            }
            
            let countrySlug = components[0]
            let stateSlug = components[1]
            let signId = components[2]
            
            
            
            return [BrowseRoute.state(CountrySlim(id: countrySlug, name: countrySlug, subdivisionName: "", url: "https://roadsign.pictures/country/\(countrySlug)/index.json")),
                    BrowseRoute.stateDetails(StateSlim(id: stateSlug, name: stateSlug, url: "https://roadsign.pictures/state/\(stateSlug)/index.json")),
                    BrowseRoute.sign(signId)]
        default:
            return nil
        }
        
        
    }
    
    
    /*
     
     
     private func handleIncomingURL(_ url: URL) {
         
         // Update random screen to just take a sign id

         
         guard let signId = components.queryItems?.first(where: {$0.name == "id"})?.value else {
             return
         }
          
         self.signId = signId
         activeTab  = .random
     }
     */
}

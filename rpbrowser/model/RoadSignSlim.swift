//
//  RoadSign.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//


import Foundation

struct RoadSignSlim: Codable, Hashable, Identifiable, Equatable, SignRowRecord {
    let id: String
    let title: String
    let image: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "imageid"
        case title
        case url
        case image
    }
    
    func getImageUrl() -> String {
        return self.image
    }
    
    
    /*
    // MARK: - Preview
    static var example: RoadSign {
        guard let sampleData = try? SampleDataLoader.loadSampleData() else {
            return RoadSign(id: "", latitude: 0.0, longitude: 0.0, country: "", countrySlug: "", county: "", countySlug: "", place: "", placeSlug: "", state: "", stateSlug: "", dateTaken: "", description: "", quality: 0, title: "", highways: [], url: "")
        }
        
        return sampleData.sign.ToRoadSign()
    }
     */
     
}


    

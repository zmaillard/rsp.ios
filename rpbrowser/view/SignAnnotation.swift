//
//  SignAnnotation.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/25/26.
//

import Foundation
import MapLibre

class SignAnnotation: NSObject, MLNAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let imageid: String
    
    init(coordinate: CLLocationCoordinate2D, imageid: String, title: String) {
        self.coordinate = coordinate
        self.imageid = imageid
        self.title = title
        self.subtitle = "Tap for details"
        super.init()
    }
}

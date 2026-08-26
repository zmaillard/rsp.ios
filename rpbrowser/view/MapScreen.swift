//
//  MapScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/25/26.
//

import Foundation
import SwiftUI

struct MapScreen: View {
    var body: some View {
        MapView() { f in
           print(f)
        }
    }
}

//struct MapScreen: UIViewControllerRepresentable {
//   typealias UIViewControllerType = MapView
//    
//    // TODO: Add router binding when navigation is implemented
//    // @Binding var router: Router
//    
//    func makeUIViewController(context: Context) -> MapView {
//        let mapView = MapView()
//        
//        // Stub: wire up navigation callback
//        mapView.onSignTapped = { signId in
//            print("🚧 MapScreen stub: received tap for sign \(signId)")
//            // TODO: router.push(.sign(signId))
//        }
//        
//        return mapView
//    }
//    
//    func updateUIViewController(_ uiViewController: MapView, context: Context) {
//    }
//}

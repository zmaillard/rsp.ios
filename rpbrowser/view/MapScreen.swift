//
//  MapScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/25/26.
//

import Foundation
import SwiftUI
import MapLibre

struct MapScreen: View {
    @SwiftUI.Environment(\.horizontalSizeClass) var sizeClass
    
    var mapViewModel = MapViewModel()
    @State private var newExtent: Rectangle?
    
    
    var body: some View {
        NavigationStack {
            if sizeClass == .compact {
                MapView(onSignTapped: onCallback, onExtentChanged: nil).navigationTitle("Map")
            } else {
                HStack {
                    MapView(onSignTapped: onCallback, onExtentChanged: onExtentChanged).navigationTitle("Map")
                    
                    
                    switch mapViewModel.state {
                    case .idle:
                        List {
                            
                        }
                    case .loading:
                        List {
                            
                        }
                    case .loaded(let signs):
                        List(signs){ sign in
                            NavigationLink(value: sign){
                                SignRow(sign: sign)
                            }
                        }
                        .navigationDestination(for: RoadSign.self)
                        {
                            sign in SignLoadingView(signId: sign.id, roadSignViewModel: StaticSignViewModel())
                        }
                    case .error(let error):
                        Text(error).foregroundStyle(Color.red)
                    }
                    
                }
            }
        }.task(id: newExtent) {
            if let newExtent {
                await mapViewModel.fetchSigns(for: newExtent)
            }
        }
    }
    
    func onCallback(signId: String) {
        print(signId)
    }
    
    func onExtentChanged(bounds: MLNCoordinateBounds) {
        self.newExtent = Rectangle.from(mapView: bounds)
    }
}

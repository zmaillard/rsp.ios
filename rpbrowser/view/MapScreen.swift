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
    @Bindable var router: Router<MapRoute>
    
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            DynamicAdaptiveStack{
                MapView(onSignTapped: onCallback, onExtentChanged: onExtentChanged)
            }
            sidebar:  {
                switch mapViewModel.state {
                case .idle:
                    List {
                        
                    }
                case .loading:
                    List {
                        
                    }
                case .loaded(let signs):
                    List(signs){ sign in
                        NavigationLink(value: MapRoute.sign(sign.id)) {
                            SignRow(sign: sign)
                        }
                    }.frame(maxWidth: .infinity)
                case .error(let error):
                    Text(error).foregroundStyle(Color.red)
                }
            }
            .navigationDestination(for: MapRoute.self) {route in
                switch route {
                case .sign(let signId):
                    SignLoadingView(signId: signId, roadSignViewModel: StaticSignViewModel())
                }
            }
        }.task(id: newExtent) {
            if let newExtent {
                print(newExtent)
                await mapViewModel.fetchSigns(for: newExtent)
            }
        }
    }
    
    func onCallback(signId: String) {
        self.router.push(MapRoute.sign(signId))
    }
    
    func onExtentChanged(bounds: MLNCoordinateBounds) {
        self.newExtent = Rectangle.from(mapView: bounds)
    }
    
    func sidebar() -> some View {
        Text("")
    }
    
    
}

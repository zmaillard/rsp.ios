//
//  ContentView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countryViewModel = CountryViewModel()
    @State private var activeTab: TabIdentifier = .random
    @State private var signId: String?
    @State private var router: Router = Router()
    
    var body: some View {
        TabView(selection: $activeTab) {
            Tab("Random", systemImage: "shuffle", value: TabIdentifier.random) {
                if let signId = signId {
                    StaticSignScreen(signId: signId) {
                        self.signId = nil
                    }
                } else {
                    RandomScreen(countryViewModel: countryViewModel, randomViewModel: RandomViewModel())
                }
            }
            Tab("Browse", systemImage: "rectangle.stack.fill", value: TabIdentifier.browse) {
                BrowseScreen(router: router, countryViewModel: countryViewModel)
            }
            Tab("Location", systemImage: "mappin.and.ellipse", value: TabIdentifier.location) {
                LocationScreen()
            }
            Tab(value: TabIdentifier.search, role: .search ) {
                SearchScreen()
            }
        }.task{
            await countryViewModel.fetch()
        }.onOpenURL { incomingURL in
            if let routes = DeepLinkParser.Parse(incomingURL) {
                self.activeTab = .browse
                self.router.setPath(routes)
            }
        }
        
    }
    
}

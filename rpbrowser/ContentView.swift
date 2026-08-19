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
                BrowseScreen(countryViewModel: countryViewModel)
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
            print("App was opened via URL: \(incomingURL)")
            handleIncomingURL(incomingURL)
        }
        
    }
    
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "rpbrowser" else {
            return
        }
        
        
        // Update random screen to just take a sign id

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        
        guard let action = components.host, action == "show-sign" else {
            return
        }
        
        guard let signId = components.queryItems?.first(where: {$0.name == "id"})?.value else {
            return
        }
         
        self.signId = signId
        activeTab  = .random
    }
}

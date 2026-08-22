//
//  ContentView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countryViewModel = CountryViewModel()
    @State private var signId: String?
    @State private var router: AppRouter = AppRouter()
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Random", systemImage: "shuffle", value: TabIdentifier.random) {
                RandomScreen(randomViewModel: RandomViewModel())
            }
            Tab("Browse", systemImage: "rectangle.stack.fill", value: TabIdentifier.browse) {
                BrowseScreen(router: router.browseRouter)
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
            print(incomingURL)
            if let routes = DeepLinkParser.Parse(incomingURL) {
                self.router.navigateTo(tab: .browse)
                self.router.browseRouter.setPath(routes)
            }
        }.environment(countryViewModel)
    }
    
}

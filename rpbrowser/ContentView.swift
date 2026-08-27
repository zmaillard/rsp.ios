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
            Tab("Map", systemImage: "map.fill", value: TabIdentifier.map) {
                // TODO: Pass router to enable navigation from map
                // MapScreen(router: router.browseRouter)
                MapScreen()
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
            print("🔗 Deep link received: \(incomingURL)")
            if let routes = DeepLinkParser.Parse(incomingURL) {
                print("📍 Parsed \(routes.count) routes from deep link")
                self.router.navigateTo(tab: .browse)
                print("🔄 Switched to Browse tab")
                
                Task { @MainActor in
                    // Ensure country data is loaded before navigation
                    print("⏳ Waiting for country data...")
                    await countryViewModel.fetch()
                    print("✅ Country data ready, state: \(countryViewModel.state)")
                    
                    // Delay to ensure Browse tab is fully rendered (100ms for reliability)
                    try? await Task.sleep(for: .milliseconds(100))
                    print("🚀 Setting navigation path with \(routes.count) routes")
                    
                    self.router.browseRouter.setPath(routes)
                    print("✓ Navigation path set successfully")
                }
            } else {
                print("❌ Failed to parse deep link URL")
            }
        }.environment(countryViewModel)
    }
    
}

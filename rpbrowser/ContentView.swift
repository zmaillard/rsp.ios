//
//  ContentView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countryViewModel = CountryViewModel()
    var body: some View {
        
        TabView {
            Tab("Browse", systemImage: "rectangle.stack.fill") {
                BrowseScreen(countryViewModel: countryViewModel)
            }
            Tab("Location", systemImage: "mappin.and.ellipse") {
                LocationScreen()
            }
            Tab("Random", systemImage: "shuffle") {
                RandomScreen(countryViewModel: countryViewModel)
            }
            
            Tab(role: .search) {
                SearchScreen()
            }
        }.task{
            await countryViewModel.fetch()
        }

    }
}

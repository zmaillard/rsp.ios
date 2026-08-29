//
//  BrowseScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//

import SwiftUI

struct BrowseScreen: View {
    @SwiftUI.Environment(CountryViewModel.self) var countryViewModel: CountryViewModel
   
    @Bindable var router: Router<BrowseRoute>

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                switch countryViewModel.state {
                case .idle:
                    Text("No data yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let countries):
                    List {
                        ForEach(countries.countries.sorted()) { country in
                            Section(country.name) {
                                let states = country.states ?? []
                                ForEach(states.sorted()) { state in
                                    NavigationLink(value: BrowseRoute.stateDetails(state)){
                                        Text(state.name).badge(state.imageCount)
                                    }
                                }
                            }
                        }
                    }
                case .error(let error):
                    Text(error).foregroundStyle(Color.red)
                }
            }
            .navigationTitle("Browse for Signs")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: BrowseRoute.self) {route in
                switch route {
                case .stateDetails(let state):
                    CountyListView(state: state, stateDetailsViewModel: StateDetailsViewModel())
                case .highwayList(let highwaySearch):
                    SignSearchView(searchType: highwaySearch)
                case .countylist(let stateName, let countyUrl):
                    SignListView(title: stateName, url: countyUrl)
                case .placelist(let stateName, let placeUrl):
                    SignListView(title: stateName, url: placeUrl)
                case .sign(let signId):
                    SignLoadingView(signId: signId, roadSignViewModel: StaticSignViewModel())
                }
            }
        }
        .environment(router)
            
    }
}

#Preview {
    BrowseScreen(router: Router()).environment(CountryViewModel.example)
 }

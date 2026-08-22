//
//  BrowseScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//

import SwiftUI

struct BrowseScreen: View {
    @Bindable var router: Router
    let countryViewModel: CountryViewModel

    var body: some View {
        NavigationStack(path: $router.path) {
            switch countryViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let countries):
                List(countries.countries.sorted()){ country in
                    NavigationLink(value: BrowseRoute.state(country)){
                        Text(country.name)
                    }
                }
                .navigationTitle("Browse for Signs")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: BrowseRoute.self) {route in
                    switch route {
                    case .state(let country):
                        StateListView(country: country, countryDetailsViewModel: CountryDetailsViewModel())
                    case .stateDetails(let state):
                        CountyListView(state: state, stateDetailsViewModel: StateDetailsViewModel())
                    case .highwayList(let highwaySearch):
                        SignListView(searchType: highwaySearch)
                    case .countylist(let countySearch):
                        SignListView(searchType: countySearch)
                    case .placelist(let placeSearch):
                        SignListView(searchType: placeSearch)
                    case .sign(let signId):
                        SignLoadingView(signId: signId)
                    }
                    
                }


            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }
        .environment(router)
            
    }
}

 #Preview {
     BrowseScreen(router: Router(), countryViewModel: CountryViewModel.example)
 }

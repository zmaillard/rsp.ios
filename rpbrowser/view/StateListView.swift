//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct StateListView: View {
    let country:CountrySlim
    let countryDetailsViewModel: CountryDetailsViewModel
    
    var body: some View {
        NavigationView {
            switch countryDetailsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let country):
                List(country.states.sorted()){ state in
                    NavigationLink(value: BrowseRoute.stateDetails(state)){
                        Text(state.name)
                    }
                }.navigationTitle("\(country.subdivisionName)s in \(country.name)")
                 .navigationBarTitleDisplayMode(.inline)
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task{
            await countryDetailsViewModel.fetch(for: country)
        }
    }
}


#Preview {
    StateListView(country: CountrySlim.example, countryDetailsViewModel: CountryDetailsViewModel.example)
}

//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct StateListView: View {
    let country:CountrySlim
    
    init(country: CountrySlim) {
        self.country = country
    }
    
    var countryDetailsViewModel = CountryDetailsViewModel()
    var body: some View {
        VStack {
            switch countryDetailsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let country):
                List(country.states){ state in
                    NavigationLink(value: state){
                        Text(state.name)
                    }
                }
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task{
            await countryDetailsViewModel.fetch(for: country)
        }
    }
}



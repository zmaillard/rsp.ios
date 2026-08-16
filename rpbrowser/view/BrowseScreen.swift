//
//  BrowseScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//

import SwiftUI

struct BrowseScreen: View {
    let countryViewModel: CountryViewModel
    
    var body: some View {
        NavigationStack {
            switch countryViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let countries):
                List(countries.countries.sorted()){ country in
                    NavigationLink(value: country){
                        Text(country.name)
                    }
                }.navigationDestination(for: CountrySlim.self)
                { country in StateListView(country: country, countryDetailsViewModel: CountryDetailsViewModel())
                    
                }.navigationDestination(for: SearchType.self)
                { searchType in SignListView(searchType: searchType)
                    
                }.navigationDestination(for: StateSlim.self)
                { state in CountyListView(state: state, stateDetailsViewModel: StateDetailsViewModel())
                    
                }.navigationDestination(for: RoadSign.self)
                { sign in SignDetailView(sign: sign){}
                    
                }



            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }
    }
}

 #Preview {
     BrowseScreen(countryViewModel: CountryViewModel.example)
 }

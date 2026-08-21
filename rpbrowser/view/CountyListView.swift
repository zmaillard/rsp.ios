//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct CountyListView: View {
    let state:StateSlim
    let stateDetailsViewModel: StateDetailsViewModel
    
    
    var body: some View {
        NavigationView {
            switch stateDetailsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let state):
                List {
                    Section("Counties") {
                        ForEach(state.stateSubdivisions.sorted()){ county in
                            NavigationLink(value: BrowseRoute.countylist(SearchType.StateSubdivisionFilter(county.id))){
                                Text(county.name)
                            }
                        }
                    }
                    Section("Places") {
                        ForEach(state.places.sorted()){ place in
                            NavigationLink(value: BrowseRoute.placelist(SearchType.PlaceFilter(place.id))){
                                Text(place.name)
                            }
                        }
                    }
                    Section("Highways") {
                        ForEach(state.highways.sorted()){ highway in
                            NavigationLink(value: BrowseRoute.highwayList(SearchType.Term(highway.name))){ //TODO: Filter highway
                                Text(highway.name)
                            }
                        }
                    }
                }.navigationTitle("Details for \(state.name)")
                 .navigationBarTitleDisplayMode(.inline)

            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task{
            await stateDetailsViewModel.fetch(for: state)
        }
    }
}

#Preview {
    CountyListView(state: StateSlim.example, stateDetailsViewModel: StateDetailsViewModel.example)
}

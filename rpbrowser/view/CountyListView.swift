//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct CountyListView: View {
    let state:StateSlim
    @State var stateDetailsViewModel: StateDetailsViewModel
    
    
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
                    if state.subdivisionName != nil && state.stateSubdivisions?.isEmpty == false {
                        Section(state.subdivisionName!) {
                            let stateSubs = state.stateSubdivisions ?? []
                            ForEach(stateSubs.sorted()){ county in
                                NavigationLink(value: BrowseRoute.countylist("\(county.name), \(state.name)", county.url)){
                                    Text(county.name).badge(county.imageCount)
                                }
                            }
                        }
                    }
                    if state.places?.isEmpty == false {
                        Section("Places") {
                            let places = state.places ?? []
                            ForEach(places.sorted()){ place in
                                NavigationLink(value: BrowseRoute.placelist("\(place.name), \(state.name)", place.url)){
                                    Text(place.name).badge(place.imageCount)
                                }
                            }
                        }
                    }
                    if state.highways?.isEmpty == false {
                        Section("Highways") {
                            let highways = state.highways ?? []
                            ForEach(highways.sorted()){ highway in
                                NavigationLink(value: BrowseRoute.highwayList(SearchType.Term(highway.name))){ //TODO: Filter highway
                                    HighwayRow(highway: highway)
                                }
                            }
                        }
                    }
                }.navigationTitle("Details for \(state.name)")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task{
            print("Loading counties")
            await stateDetailsViewModel.fetch(for: state)
        }
    }
}

#Preview {
    CountyListView(state: StateSlim.example, stateDetailsViewModel: StateDetailsViewModel.example)
}

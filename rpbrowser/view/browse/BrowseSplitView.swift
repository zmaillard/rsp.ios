//
//  BrowseSplitView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 9/5/26.
//

import Foundation
import SwiftUI

struct BrowseSplitView: View {
    enum BrowseSplitViewSelection: Hashable, Equatable {
        case browseUrl(String, String)
        case browseSearch(SearchType)
    }
    
    let state:StateSlim
    @State private var roadSignListViewModel = RoadSignListViewModel()
    @State private var roadSignsViewModel = RoadSignsViewModel()
    @State var stateDetailsViewModel: StateDetailsViewModel
    @State private var selection: BrowseSplitViewSelection? = nil
    @State private var signSelection: String? = nil

    init(
        state: StateSlim,
        stateDetailsViewModel: StateDetailsViewModel,
        roadSignListViewModel: RoadSignListViewModel = RoadSignListViewModel(),
        roadSignsViewModel: RoadSignsViewModel = RoadSignsViewModel(),
        initialSelection: BrowseSplitViewSelection? = nil,
        initialSignSelection: String? = nil
    ) {
        self.state = state
        self._roadSignListViewModel = State(initialValue: roadSignListViewModel)
        self._roadSignsViewModel = State(initialValue: roadSignsViewModel)
        self._stateDetailsViewModel = State(initialValue: stateDetailsViewModel)
        self._selection = State(initialValue: initialSelection)
        self._signSelection = State(initialValue: initialSignSelection)
    }

    var body: some View {
        NavigationSplitView {
            switch stateDetailsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let state):
                List(selection: $selection) {
                    if let subdivisionName = state.subdivisionName{
                        Section(subdivisionName) {
                            let stateSubs = state.stateSubdivisions ?? []
                            ForEach(stateSubs.sorted()){ county in
                                Text(county.name).badge(county.imageCount).tag(BrowseSplitViewSelection.browseUrl("\(county.name), \(state.name)", county.url))
                            }
                        }
                    }
                    if state.places?.isEmpty == false {
                        Section("Places") {
                            let places = state.places ?? []
                            ForEach(places.sorted()){ place in
                                Text(place.name).badge(place.imageCount).tag(BrowseSplitViewSelection.browseUrl("\(place.name), \(state.name)", place.url))
                                
                            }
                        }
                    }
                    if state.highways?.isEmpty == false {
                        Section("Highways") {
                            let highways = state.highways ?? []
                            ForEach(highways.sorted()){ highway in
                                HighwayRow(highway: highway).tag(BrowseSplitViewSelection.browseSearch(SearchType.Term(highway.name)))
                            }
                        }
                    }
                }.navigationTitle("Details for \(state.name)")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        } content: {
            switch selection {
            case .browseUrl(_,_):
                switch roadSignListViewModel.state {
                case .idle:
                    Text("No data yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let searchResult):
                    List(searchResult.signs, selection: $signSelection){ sign in
                        SignRowSlim(sign: sign)
                    }
                case .error(let error):
                    Text(error).foregroundStyle(Color.red)
                }
            case .browseSearch(_):
                switch roadSignsViewModel.state {
                case .idle:
                    Text("No data yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let searchResult):
                    List(searchResult.signs, selection: $signSelection){ sign in
                        SignRow(sign: sign).tag(sign.id)
                    }
                case .error(let error):
                    Text(error).foregroundStyle(Color.red)
                }
            case .none:
                Text("Choose a location")
            }
        } detail: {
            if let signId = signSelection {
                SignLoadingView(signId: signId, roadSignViewModel: StaticSignViewModel())
            } else {
                Text("Select a sign to view details")
            }
        }.task(id: selection) {
            await handleSelectionChange(selection)
        }.task {
            await stateDetailsViewModel.fetch(for: state)
        }
    }

    func handleSelectionChange(_ selected: BrowseSplitViewSelection?) async {
        self.signSelection = nil
        switch selected {
        case .browseUrl(_, let url):
            await roadSignListViewModel.fetchSigns(url: url)
        case .browseSearch(let searchType):
            await roadSignsViewModel.fetchSigns(searchType: searchType)
        case .none:
            break
        }
    }
}

/*
 
 let title: String
 let url:String
 

 var roadSignListViewModel = RoadSignListViewModel()
 var body: some View {
     VStack {
         switch roadSignListViewModel.state {
         case .idle:
             Text("No data yet")
         case .loading:
             ProgressView {
                 Text("Loading...")
             }.navigationTitle("Loading Signs")
         case .loaded(let searchResult):
             List(searchResult.signs){ sign in
                 NavigationLink(value: BrowseRoute.sign(sign.id)){
                     SignRowSlim(sign: sign)
                 }
             }.navigationTitle(title)
         case .error(let error):
             Text(error).foregroundStyle(Color.red)
         }
     }.task{
         await roadSignListViewModel.fetchSigns(url: self.url)
     }
 }
 */

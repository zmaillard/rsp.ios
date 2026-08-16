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
        VStack {
            switch stateDetailsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let state):
                List(state.stateSubdivisions.sorted()){ county in
                    NavigationLink(value: SearchType.StateSubdivisionFilter(county.id)){
                        Text(county.name)
                    }
                }
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

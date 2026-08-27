//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct SignSearchView: View {
    @SwiftUI.Environment(Router.self) var router:Router
    
    let searchType:SearchType
    
   
    init(searchType: SearchType) {
        self.searchType = searchType
    }

    var roadSignsViewModel = RoadSignsViewModel()
    var body: some View {
        VStack {
            switch roadSignsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }.navigationTitle("Loading Signs")
            case .loaded(let searchResult):
                List(searchResult.signs){ sign in
                    NavigationLink(value: BrowseRoute.sign(sign.id)){
                        SignRow(sign: sign)
                    }
                }.navigationTitle(searchResult.title)
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task{
            await roadSignsViewModel.fetchSigns(searchType: searchType)
        }
    }
}

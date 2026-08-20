//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct SignListView: View {
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
                }
            case .loaded(let signs):
                List(signs){ sign in
                    NavigationLink(value: BrowseRoute.sign(sign)){
                        SignRow(sign: sign)
                    }
                }
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task{
            await roadSignsViewModel.fetchSigns(searchType: searchType)
        }
    }
}

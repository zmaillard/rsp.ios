//
//  SignListView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct SignListView: View {
    
    let title: String
    let url:String
    

    @State var roadSignListViewModel: RoadSignListViewModel
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
}

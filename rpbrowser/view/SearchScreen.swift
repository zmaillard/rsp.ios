//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI

struct SearchScreen: View {
    var staticSignViewModel = StaticSignViewModel()
    
    @State private var text: String = ""
    @State private var roadSignsViewModel = SearchViewModel()
    @State private var selectedSign: RoadSign?
    var body: some View {
        NavigationSplitView {
            switch roadSignsViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let signs):
                List(signs){ sign in
                    NavigationLink(value: sign){
                        SignRow(sign: sign)
                    }
                }
                .navigationDestination(for: RoadSign.self)
                {
                    sign in SignLoadingView(signId: sign.id, roadSignViewModel: StaticSignViewModel())
                }
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        } detail: {
            if let sign = selectedSign {
                SignLoadingView(signId: sign.id, roadSignViewModel: staticSignViewModel)
            } else {
                ContentUnavailableView("No sign selected",
                                       systemImage: "sidebar.left",
                description: Text("Choose a sign from the sidebar"))
            }
        }
        .navigationTitle("Search for signs")
        .searchable(text: $text)
        .task(id: text){
            await roadSignsViewModel.fetchSigns(for: text)
        }
        
    }
}

#Preview {
    SearchScreen()
}

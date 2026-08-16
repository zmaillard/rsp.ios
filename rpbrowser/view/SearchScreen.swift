//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI

struct SearchScreen: View {
    @State private var text: String = ""
    @State private var roadSignsViewModel = SearchViewModel()
    var body: some View {
        
        NavigationStack {
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
                        NavigationLink(value: sign){
                            SignRow(sign: sign)
                        }
                    }
                    .navigationDestination(for: RoadSign.self)
                        {
                            sign in SignDetailView(sign: sign, onRefresh: nil)
                        }
                case .error(let error):
                    Text(error).foregroundStyle(Color.red)
                }
            }
        }
        .navigationTitle("Search for signs")
        .searchable(text: $text)
        .task(id: text){
            await roadSignsViewModel.fetchSigns(for: text)
        }
        
    }
}

/*
#Preview {
    SearchScreen()
}
*/

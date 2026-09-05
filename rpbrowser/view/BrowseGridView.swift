//
//  BrowseGridView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 9/5/26.
//

import Foundation
import SwiftUI

struct BrowseGridView: View {
    let index: Index
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                ForEach(index.countries.sorted()) { country in
                    Text(country.name).font(.headline).bold()
                    ScrollView(.horizontal) {
                        LazyHStack {
                            let states = country.states ?? []
                            ForEach(states.sorted()) { state in
                                if state.featured != nil {
                                    NavigationLink(value: BrowseRoute.stateDetails(state)){
                                        StateGridView(state: state)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BrowseGridView(index: Index.example)
}

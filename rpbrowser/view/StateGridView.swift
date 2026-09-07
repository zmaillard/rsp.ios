//
//  StateGridView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 9/5/26.
//

import SwiftUI
import Kingfisher

struct StateGridView: View {
    let state: StateSlim

    private var featuredImageURL: URL? {
        guard let medium = state.featured?.medium else {
            return nil
        }
        return URL(string: medium)
    }
    
    var body: some View {
        VStack {
            if let featuredImageURL {
                KFImage.url(featuredImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
            } else {
                Color.gray.opacity(0.2)
                    .frame(height: 200)
            }
                
            HStack{
                Text(state.name).font(.headline)
                Text("\(state.imageCount)")
                    .padding(5)
                    .background(
                        Color.accentColor.opacity(0.2),
                        in: Capsule()
                    )
            }
        }
    }
}

#Preview {
    StateGridView(state: StateSlim.example)
}

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
            /*
            AsyncImage(url: URL(string: state.featured!.medium)) { phase in
                switch phase {
                case .empty:
                    Color(white: 0.8)
                        .overlay {
                            ProgressView()
                                .controlSize(.large)
                        }
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure(_):
                    Text("Could not load image")
                @unknown default:
                    fatalError()
                }
            }.frame(height: 200)
             */
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

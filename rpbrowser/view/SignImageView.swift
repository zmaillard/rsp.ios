//
//  SignImageView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//

import SwiftUI

public struct SignImageView: View {
    let urlPath: String
    
    public var body: some View {
        AsyncImage(url: URL(string: urlPath)) { phase in
            switch phase {
            case .empty:
                Color(white: 0.8)
                    .overlay {
                        ProgressView()
                            .controlSize(.large)
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(_):
                Text("Could not load image")
                @unknown default:
                    fatalError()
            }
            
        }
    }
}

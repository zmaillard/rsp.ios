//
//  SignImageView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//

import SwiftUI

public struct SignImageView: View {
    let urlPath: String
    var callback: (() -> Void)? = nil
    
    
    
    public var body: some View {
        let tap =    TapGesture(count: 1).onEnded { _ in
            if let callback = self.callback {
                callback()
            }
        }
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
            
        }.gesture(tap)
        
    }
}
#Preview {
    let url = RoadSign.example.url
    SignImageView(urlPath: url)
}
 

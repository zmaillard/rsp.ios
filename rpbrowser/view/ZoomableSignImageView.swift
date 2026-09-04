//
//  SignImageView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//

import SwiftUI

public struct ZoomableSignImageView: View {
    let urlPath: String
    let imageViewModel: ImageLoaderViewModel = ImageLoaderViewModel()
    
    public var body: some View {
        Group {
            
            switch imageViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let uiImage):
                ZoomableImageView(image: uiImage)
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        }.task {
            await imageViewModel.fetch(for: self.urlPath)
        }
        
        
        
        
        
        /*
         AsyncImage(url: URL(string: urlPath)) { phase in
         switch phase {
         case .empty:
         Color(white: 0.8)
         .overlay {
         ProgressView()
         .controlSize(.large)
         }
         case .success(let image):
         
         ZoomablePannableView {
         image
         .resizable()
         .scaledToFit()
         }.background(Color.black.edgesIgnoringSafeArea(.all))
         case .failure(_):
         Text("Could not load image")
         @unknown default:
         fatalError()
         }
         
         }*/
    }
}
/*
 #Preview {
 let url = RoadSign.example.url
 SignImageView(urlPath: url)
 }
 */

//
//  FullScreenModalView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 9/4/26.
//

import SwiftUI

struct FullScreenModalView: View {
    @SwiftUI.Environment(\.dismiss) var dismiss
    let imageUrl: String
    let imageSize: CGFloat
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                //Color.primary.edgesIgnoringSafeArea(.all)
                ZoomableSignImageView(urlPath: imageUrl)
            }
            .toolbar {
                Button(role: .close) {
                    dismiss()
                }
            }
        }
    }
}

/*
 #Preview {
 FullScreenModalView()
 }
 */

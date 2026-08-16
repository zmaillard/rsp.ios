//
//  LoadingView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text("Loading signs...")
                .foregroundColor(.gray)
                
        }
    }
}

/*
#Preview {
    LoadingView()
}
*/

//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI

struct SignLoadingView: View {
    let signId: String
    @State var roadSignViewModel: StaticSignViewModel
    
    var body: some View {
        VStack {
            // Display content based on randomViewModel.state
            switch roadSignViewModel.state {
            case .idle:
                ProgressView("Loading...")
            case .loading:
                ProgressView("Loading random sign...")
            case .loaded(let sign):
                SignDetailView(sign: sign, onRefresh: nil)
            case .error(let message):
                // Stub: will implement error handling later
                Text("Error: \(message)")
            }
        }
        .task(id: signId) {
            await roadSignViewModel.fetch(signId: self.signId)
        }
    }
}


/*
 #Preview {
 SignLoadingView()
 }
 */

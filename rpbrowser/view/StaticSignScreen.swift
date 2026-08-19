//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI

struct StaticSignScreen: View {
    let signId: String
    let callback: () -> Void
    let staticSignViewModel: StaticSignViewModel = StaticSignViewModel()
    
    var body: some View {
        VStack {
            // Display content based on randomViewModel.state
            switch staticSignViewModel.state {
            case .idle:
                ProgressView("Loading...")
            case .loading:
                ProgressView("Loading random sign...")
            case .loaded(let sign):
                SignDetailView(sign: sign.ToRoadSign()) {
                    callback()
                }
            case .error(let message):
                // Stub: will implement error handling later
                Text("Error: \(message)")
            }
        }
        .task(id: signId) {
            await staticSignViewModel.fetch(signId: signId)
        }
    }
}


#Preview {
    RandomScreen(countryViewModel: CountryViewModel.example, randomViewModel: RandomViewModel.example)
}

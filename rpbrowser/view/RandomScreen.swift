//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI

struct RandomScreen: View {
    let countryViewModel: CountryViewModel
    let randomViewModel: RandomViewModel
    
    private var imageCount: Int  {
        switch countryViewModel.state {
        case .loaded(let countries):
            return countries.imageCount
        default: return 0
        }
    }
    
    var body: some View {
        NavigationStack {
            // Display content based on randomViewModel.state
            switch randomViewModel.state {
            case .idle:
                ProgressView("Loading...")
            case .loading:
                ProgressView("Loading random sign...")
            case .loaded(let sign):
                SignDetailView(sign: sign.ToRoadSign()) {
                    Task {
                        await randomViewModel.fetch(count: imageCount)
                    }
                }.navigationTitle(sign.title)
            case .error(let message):
                // Stub: will implement error handling later
                Text("Error: \(message)")
            }
        }
        .task(id: imageCount) {
            await randomViewModel.fetch(count: imageCount)
        }
    }
}


#Preview {
    RandomScreen(countryViewModel: CountryViewModel.example, randomViewModel: RandomViewModel.example)
}

//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI
import CoreLocation

struct LocationScreen: View {
    var locationDataManager: LocationDataManager
    var locationViewModel = LocationViewModel()
    var staticSignViewModel = StaticSignViewModel()
    
    init(location: LocationDataManager = DeviceLocationDataManager()) {
        self.locationDataManager = location
    }

    @State var location: CLLocation?
    @State private var selectedSign: RoadSign?
    
    var body: some View {
        NavigationSplitView {
            switch locationViewModel.state {
            case .idle:
                Text("No data yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let searchResults):
                List(searchResults.signs, selection: $selectedSign){ sign in
                    NavigationLink(value: sign){
                        SignRow(sign: sign)
                    }
                }
                .navigationTitle(searchResults.title)
                
            case .error(let error):
                Text(error).foregroundStyle(Color.red)
            }
        } detail: {
            if let sign = selectedSign {
                SignLoadingView(signId: sign.id, roadSignViewModel: staticSignViewModel)
            } else {
                ContentUnavailableView("No sign selected",
                                       systemImage: "sidebar.left",
                description: Text("Choose a sign from the sidebar"))
            }
        }
        .task{
            do {
                self.location = try await locationDataManager.currentLocation
                await locationViewModel.fetchSigns(for: location)
            } catch {
               print("nope")
            }
        }
        
    }
}


#Preview {
    LocationScreen(location: MockLocationDataManager())
}

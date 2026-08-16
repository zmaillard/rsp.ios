//
//  RandomScreen.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/10/26.
//
import SwiftUI
import CoreLocation

struct LocationScreen: View {
    var locationDataManager = LocationDataManager()
    var locationViewModel = LocationViewModel()
    
    @State var location: CLLocation?
    
    var body: some View {
        NavigationStack {
            VStack {
                switch locationViewModel.state {
                case .idle:
                    Text("No data yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let signs):
                    List(signs){ sign in
                        NavigationLink(value: sign){
                            SignRow(sign: sign)
                        }
                    }
                    .navigationDestination(for: RoadSign.self)
                        {
                            sign in SignDetailView(sign: sign, onRefresh: nil)
                        }
                case .error(let error):
                    Text(error).foregroundStyle(Color.red)
                }
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

/*

#Preview {
    SearchScreen()
}
*/

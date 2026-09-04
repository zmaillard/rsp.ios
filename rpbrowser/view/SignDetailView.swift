//
//  SignDetailVilew.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI
import MapKit

struct SignDetailView: View {
    let sign: RoadSignDetails
    let onRefresh:(() -> Void)?
    let imageSize: CGFloat = 500.0
    @State private var isPresented: Bool = false
    
    
    var body: some View {
        ScrollView {
            DynamicStack {
                VStack {
                    SignImageView(urlPath: sign.image.large) { self.isPresented = true }
                        .frame(height: imageSize)
                        .clipped()
                    let desc: LocalizedStringKey = LocalizedStringKey(trimTags(from: sign.description))
                    Text(desc)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        ForEach(sign.highways) { h in
                            SignImageView(urlPath: h.shield.large)
                                .frame(width: 30.0, height: 30.0)
                                .clipped()
                        }
                    }
                    HStack {
                        if sign.place != nil{
                            Text(sign.place!.name).font(.footnote)
                        }
                        if sign.stateSubdivision != nil{
                            Text(sign.stateSubdivision!.name).font(.footnote)
                        }
                        Text(sign.state.name).font(.footnote)
                        Text(sign.country.name).font(.footnote)
                    }
                    Divider()
                    if let onRefresh {
                        Button("Refresh", systemImage: "shuffle"){
                            onRefresh()
                        }
                    }
                    Map {
                        Marker(sign.title, coordinate: CLLocationCoordinate2D(latitude:sign.latitude, longitude:sign.longitude))
                        
                    }
                }
                
                .padding()
                .navigationTitle(sign.title)
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $isPresented){
                    FullScreenModalView(imageUrl: sign.image.large, imageSize: imageSize)
                }
            }
        }
        
    }
    private func trimTags(from input: String) -> String {
        return input.replacing("<p>", with: "").replacing("</p>", with: "")
    }
}

/*
 
 #Preview {
 SignDetailView(sign: RoadSign.example, onRefresh: nil)
 }
 */

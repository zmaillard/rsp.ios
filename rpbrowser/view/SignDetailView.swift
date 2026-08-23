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
    let imageSize: CGFloat = 300.0
    
    
    var body: some View {
        VStack {
            SignImageView(urlPath: sign.image.large)
                .frame(height: 300)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                let desc: LocalizedStringKey = LocalizedStringKey(trimTags(from: sign.description))
                Text(desc)
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
                Map(){
                    Marker(sign.title, coordinate: CLLocationCoordinate2D(latitude:sign.latitude, longitude:sign.longitude))
                    
                }
                
                Spacer()
            }.padding()
                .navigationTitle(sign.title)
                .navigationBarTitleDisplayMode(.inline)
            
            
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

//
//  SignDetailVilew.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI
import MapKit

struct SignDetailView: View {
    let sign: RoadSign
    let onRefresh:(() -> Void)?
    let imageSize: CGFloat = 300.0
    
    
    
    var body: some View {
        VStack {
            SignImageView(urlPath: sign.url)
                .frame(height: 300)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                let desc: LocalizedStringKey = LocalizedStringKey(trimTags(from: sign.description))
                Text(desc)
                if let onRefresh {
                    Button("Refresh", systemImage: "shuffle"){
                        onRefresh()
                    }
                }
                Text("\(sign.place) | \(sign.county) | \(sign.state) | \(sign.country)").font(.footnote)
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

#Preview {
    SignDetailView(sign: RoadSign.example, onRefresh: nil)
}

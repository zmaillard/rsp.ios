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
                Text(sign.title).font(.headline)
                Text(sign.description)
                if let onRefresh {
                    Button(action: onRefresh) {
                        Text("Refresh")
                    }
                }
                Text("\(sign.place) | \(sign.county) | \(sign.state) | \(sign.country)").font(.footnote)
                Map() {
                    Marker(sign.title, coordinate: CLLocationCoordinate2D(latitude:sign.latitude, longitude:sign.longitude))
                    
                }
                
                Spacer()
            }.padding()
                .navigationBarTitleDisplayMode(.inline)
            
            
        }
    }
}


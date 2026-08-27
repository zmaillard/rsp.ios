//
//  SignRow.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct HighwayRow: View {
    let highway: HighwaySlim
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30
    var body: some View {
        HStack {
            SignImageView(urlPath: highway.shield.large)
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
            
            Text(highway.name)
        }
    }
}



#Preview {
    SignRow(sign: RoadSign.example)
}

//
//  SignRow.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct SignRow: View {
    let sign: RoadSign
    let imageWidth: CGFloat = 100
    let imageHeight: CGFloat = 100
    var body: some View {
        HStack {
            SignImageView(urlPath: sign.url.replacing("_l", with: "_s"))
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(sign.title)
                    .font(.headline)
                Text("\(sign.place) | \(sign.state)")
            }
        }
    }
}

/*

#Preview {
    SignRow(sign: RoadSign.ExampleSign())
}
*/

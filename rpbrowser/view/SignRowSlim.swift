//
//  SignRow.swift
//  rpbrowser
//
//  Created by Zach Maillard on 7/26/26.
//

import SwiftUI

struct SignRowSlim: View {
    let sign: SignRowRecord
    let imageWidth: CGFloat = 100
    let imageHeight: CGFloat = 100
    var body: some View {
        HStack {
            SignImageView(urlPath: sign.getImageUrl())
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
            
                Text(sign.title).font(.headline)
        }
    }
}



#Preview {
    SignRow(sign: RoadSign.example)
}

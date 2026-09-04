//
//  DynamicStack.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/29/26.
//

import Foundation
import SwiftUI

struct DynamicAdaptiveStack<Content: View, Sidebar: View>: View {
    @SwiftUI.Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isSheetPresented = false

    var horizontalAlignment = HorizontalAlignment.center
    var verticalAlignment = VerticalAlignment.center
    
    var spacing: CGFloat?
    
    @ViewBuilder var content: () ->  Content
    @ViewBuilder var sidebar: () -> Sidebar
    
    var body: some View {
        switch horizontalSizeClass {
        case .compact, .none:
            vstack
        case .regular:
           hstack
        @unknown default:
           vstack
        }
    }
}

private extension DynamicAdaptiveStack {
    var hstack: some View {
        HStack(alignment: verticalAlignment, spacing: spacing) {
           content()
           sidebar()
        }
    }
    
    var vstack: some View {
        VStack(alignment: horizontalAlignment, spacing: spacing) {
            content()
                .adaptiveSheet(isPresented: $isSheetPresented) {
                    sidebar()
                }
        }
    }
}

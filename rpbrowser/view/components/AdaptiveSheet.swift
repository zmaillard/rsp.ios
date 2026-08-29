//
//  AdaptiveSheet.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/28/26.
//

import Foundation
import SwiftUI

//https://medium.com/@sonyahew/swiftui-draggable-bottom-sheet-for-iphone-ipad-like-apple-maps-a7ea71ebb2d3?sk=0bf298e18bd06c27d2d36dcf69edcc18

struct AdaptiveSheet<SheetContent: View>: ViewModifier {
    @SwiftUI.Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var isPresented: Bool
    
    @State private var sheetPosition: CustomBottomSheet<SheetContent>.SheetPosition = .collapsed
    
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            CustomBottomSheet(sheetPosition: $sheetPosition, content: sheetContent)
        }
        .onChange(of: horizontalSizeClass) {old, new in
            handleSizeClassChange(from: old, to: new)
        }.onAppear {
            if horizontalSizeClass == .regular {
                isPresented = false
            }
        }
    }
    
    private func handleSizeClassChange(from old: UserInterfaceSizeClass?, to new: UserInterfaceSizeClass?) {
        if old == .regular && new == .compact{
            isPresented = (sheetPosition == .fullyExpanded)
        }
        if old == .compact && new == .regular{
            sheetPosition = isPresented ? .fullyExpanded : .collapsed
            isPresented = false
        }
    }
}

private struct CustomBottomSheet<Content: View>: View {
    enum SheetPosition {
        case collapsed, fullyExpanded
    }
    
    @SwiftUI.Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var sheetPosition: SheetPosition
    
    //we use a dragOffset to apply real-time movement,
    //and update the final position when the drag ends.
    @State private var dragOffset: CGFloat = 0
    
    let content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                //See 4. for the Handle design :)
                DragHandle { value in
                    dragOffset = value
                } onDragEnded: { value in
                    handleDragEnd(translation: value, height: geometry.size.height)
                }
                
                content()
            }
            .padding(.horizontal)
            .frame(
                width: horizontalSizeClass == .compact ? geometry.size.width : 350,
                height: geometry.size.height,
                alignment: .top
            )
            .background(.white)
            .clipShape(
                .rect(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 20
                )
            )
            .shadow(radius: 4)
            .offset(
                x: horizontalSizeClass == .compact ? 0 : geometry.size.width * 0.05,
                y: calculatedOffset(for: sheetPosition, height: geometry.size.height) + dragOffset
            )
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.8), value: dragOffset)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    //the drag logic checks if you're dragging up or down,
    private func handleDragEnd(translation: CGFloat, height: CGFloat) {
        let threshold: CGFloat = 100
        let collapsedY = calculatedOffset(for: .collapsed, height: height)
        let expandedY = calculatedOffset(for: .fullyExpanded, height: height)
        let currentY = collapsedY + dragOffset
        
        //and chooses the closest snap point:
        let newPosition: SheetPosition = {
            if translation > threshold { return .collapsed }
            if translation < -threshold { return .fullyExpanded }
            let midpoint = (collapsedY + expandedY) / 2
            return currentY > midpoint ? .collapsed : .fullyExpanded
        }()
        
        //a springy feedback
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
            sheetPosition = newPosition
            dragOffset = 0
        }
    }
    
    //my magic numbers, but feel free to adjust :)
    //offset here basically means distance from top on both states
    private func calculatedOffset(for position: SheetPosition, height: CGFloat) -> CGFloat {
        let compactOffsetPosition: CGFloat = 180
        let regularOffsetPosition: CGFloat = 80
        let expandedOffsetPositionMultiplier: CGFloat = 0.075
        
        switch position {
        case .collapsed:
            return height - (horizontalSizeClass == .compact ? compactOffsetPosition : regularOffsetPosition)
        case .fullyExpanded:
            return height * expandedOffsetPositionMultiplier
        }
    }
}

private struct DragHandle: View {
    let onDragChanged: (CGFloat) -> Void
    let onDragEnded: (CGFloat) -> Void
    
    var body: some View {
        Capsule()
            .frame(width: 40, height: 6)
            .foregroundColor(.gray)
            .padding(10)
            .contentShape(SwiftUI.Rectangle())
            .gesture(
                DragGesture()
                    .onChanged{ value in onDragChanged(value.translation.height) }
                    .onEnded{ value in onDragEnded(value.translation.height) }
            )
    }
}

extension View {
    public func adaptiveSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(AdaptiveSheet(isPresented: isPresented, sheetContent: content))
    }
}

#Preview {
    @Previewable @State var isSheetPresented = false

    ZStack {
        //a little bit too much flare here
        AngularGradient(
            gradient: Gradient(colors: [
                Color(red: 0.98, green: 0.70, blue: 0.75), //rose
                Color(red: 1.00, green: 0.80, blue: 0.55), //peach
                Color(red: 0.70, green: 0.90, blue: 0.75), //mint
                Color(red: 0.98, green: 0.70, blue: 0.75)  //rose
            ]),
            center: .center,
            angle: .degrees(270)
        )
    }
    .adaptiveSheet(isPresented: $isSheetPresented) {
        Text("A draggable sheet!")
            .padding()
    }
    .ignoresSafeArea()
}

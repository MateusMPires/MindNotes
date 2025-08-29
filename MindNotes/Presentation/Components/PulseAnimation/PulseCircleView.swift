//
//  ButtonPulseView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 28/08/25.
//
import SwiftUI

/// Pulsed Heart Animation View
struct PulseCircleView: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: "circle.fill")
            .font(.system(size: 20))
            .foregroundStyle(.accent)
            .background(content: {
                Image(systemName: "circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .blur(radius: 2, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            })
            .scaleEffect(startAnimation ? 3 : 1)
            .opacity(startAnimation ? 0 : 0.9)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

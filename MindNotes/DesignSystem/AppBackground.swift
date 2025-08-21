//
//  AppBackground.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        DesignTokens.Colors.background
            .opacity(0.1)
            .ignoresSafeArea()
    }
}

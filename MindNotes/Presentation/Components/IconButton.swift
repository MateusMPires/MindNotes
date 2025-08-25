//
//  iConButton.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import SwiftUI

struct IconButton: View {
    let iconName: String
    let size: CGFloat
    let action: () -> Void
    var isHidden: Bool = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: size))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.accent)
        }
        .opacity(isHidden ? 0 : 1)
    }
}

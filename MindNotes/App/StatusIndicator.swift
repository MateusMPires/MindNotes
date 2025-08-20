//
//  StatusIndicator.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import SwiftUI

struct StatusIndicator: View {
    let iconName: String
    let color: Color
    let size: Font
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundColor(color)
            .font(size)
    }
}

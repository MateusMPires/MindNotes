//
//  JourneyRowComponent.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 27/08/25.
//

import SwiftUI

struct JourneyRowComponent: View {
    let title: String
    let color: String
    let icon: String
    let thoughtsCount: Int
    
   
    
    var body: some View {
            HStack(spacing: DesignTokens.Spacing.md) {

                Image(systemName: icon)
                    .font(DesignTokens.Typography.tag)
                    .foregroundStyle(.white)
                    .padding(6)
                    //.frame(width: 32, height: 32)
                    .background(Color(hex: color))
                    .clipShape(Circle())
                    //.opacity(journey.isArchived ? 0.6 : 1.0)
                
                Text(title)
                    .textCase(.lowercase)
                    .font(DesignTokens.Typography.body)
                    .tint(DesignTokens.Colors.primaryText)
                
              
                
                Spacer()
                
                Text("\(thoughtsCount)")
                    .font(DesignTokens.Typography.tag)
                    .tint(Color.secondary)
                
                Image(systemName: "chevron.right")
                    .font(DesignTokens.Typography.tag)
                    .tint(.primary)
        
            }
            .padding(.vertical, 8)
        
        
    }
}

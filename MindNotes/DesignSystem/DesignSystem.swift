//
//  DesignSystem.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import SwiftUI

// 1. Design Tokens
struct DesignTokens {
    struct Colors {
//        static let background = Color(hex: "#EDE3E3")
        static let background = LinearGradient(colors: [Color(hex: "#112F3A"), Color(hex: "#153641"), Color(hex: "#224A58"), Color(hex: "#2F5E6F")], startPoint: .top, endPoint: .bottom)
           

        static let cardBackground = Color.white.opacity(0.05)
        static let strokeColor = Color.white.opacity(0.3)
        static let primary = Color(hex: "#061A21")
        static let secondaryText = Color(hex: "#404040")
        static let tag = Color(hex: "#112F3A").opacity(0.5)
        static let accent = Color.accentColor
        static let notification = Color.orange
    }
    
    struct Typography {
        static let title = Font.custom("Outfit-Medium", size: 24)
        static let subtitle = Font.custom("Outfit-Regular", size: 16)
        static let body = Font.custom("Manrope-Medium", size: 16)
        static let caption = Font.custom("Manrope-Regular", size: 12)
        static let tag = Font.custom("Manrope-Regular", size: 10)
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let huge: CGFloat = 180
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    struct Animations {
        static let quick = Animation.easeInOut(duration: 0.3)
        static let medium = Animation.easeInOut(duration: 0.6)
        static let spring = Animation.spring(duration: 0.4)
    }
}

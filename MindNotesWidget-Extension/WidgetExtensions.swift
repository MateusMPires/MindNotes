import SwiftUI
import WidgetKit

// MARK: - Widget Styling Extensions
extension View {
    func widgetBackground() -> some View {
        self.containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Deep Link Constants
struct WidgetDeepLink {
    static let newThought = "mindnotes://new-thought"
    
    static func createURL(for action: String) -> URL? {
        return URL(string: action)
    }
}

// MARK: - Widget Animation
struct WidgetAnimation {
    static let spring = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let easeInOut = Animation.easeInOut(duration: 0.3)
} 
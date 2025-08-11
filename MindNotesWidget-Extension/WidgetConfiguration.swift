import WidgetKit
import SwiftUI

extension MindNotesWidget {
    static var configurationDisplayName: String {
        return "MindNotes"
    }
    
    static var description: String {
        return "Adicione novos pensamentos rapidamente"
    }
    
    static var supportedFamilies: [WidgetFamily] {
        return [.systemSmall]
    }
} 
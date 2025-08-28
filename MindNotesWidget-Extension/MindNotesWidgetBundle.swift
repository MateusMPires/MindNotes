import WidgetKit
import SwiftUI

@main
struct MindNotesWidgetBundle: WidgetBundle {
    var body: some Widget {
        MindNotesWidget()
        EchoWidget()    // widget de ecos
    }
} 

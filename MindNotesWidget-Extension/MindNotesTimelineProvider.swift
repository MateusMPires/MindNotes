import WidgetKit
import SwiftUI

struct MindNotesTimelineEntry: TimelineEntry {
    let date: Date
}

struct MindNotesTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> MindNotesTimelineEntry {
        MindNotesTimelineEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MindNotesTimelineEntry) -> ()) {
        let entry = MindNotesTimelineEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MindNotesTimelineEntry>) -> ()) {
        let currentDate = Date()
        let entry = MindNotesTimelineEntry(date: currentDate)
        
        // Widget será atualizado a cada hora
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
} 
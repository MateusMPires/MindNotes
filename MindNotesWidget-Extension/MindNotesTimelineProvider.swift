import WidgetKit
import SwiftUI

struct MindNotesTimelineEntry: TimelineEntry {
    var date: Date
    var streak: Int
}

struct MindNotesTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> MindNotesTimelineEntry {
        MindNotesTimelineEntry(date: Date(), streak: 0)
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (MindNotesTimelineEntry) -> ()) {
        let entry = MindNotesTimelineEntry(date: Date(), streak: 0)
        completion(entry)
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MindNotesTimelineEntry>) -> ()) {
        let currentDate = Date()
        var entry: MindNotesTimelineEntry = MindNotesTimelineEntry(date: currentDate, streak: 0)
        
        if let userDefaults = UserDefaults(suiteName: "group.mindnotes") {
            let streak = userDefaults.integer(forKey: "streakCount")
            
            entry.streak = streak
        }
        
        let nextUpdate = currentDate
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

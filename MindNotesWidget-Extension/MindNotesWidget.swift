import WidgetKit
import SwiftUI

struct MindNotesWidget: Widget {
    let kind: String = "MindNotes_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: MindNotesTimelineProvider(),
            content: { MindNotesWidgetView(entry: $0) }
        )
        .configurationDisplayName("MindNotes")
        .description("Entradas")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct MindNotesWidgetView: View {
    var entry: MindNotesTimelineEntry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Sequência")
                    .font(.system(size: 12))
                    .bold()
                    .fontDesign(.rounded)
                
                Spacer()
            }
            //.padding(.top)
            
            VStack(spacing: -8) {
                Text("2")
                    .font(.system(size: 50))
                    .bold()
                
                Text("Dias")
                    .font(.system(size: 12))
                    .bold()

            }
            
            Button {
                // Deep link será tratado pelo widgetURL

            } label: {
                Label("Nova entrada", systemImage: "square.and.pencil")
             
            }
            .frame(maxWidth: .infinity)
            .font(.system(size: 12).bold())
            //                    .background(.white)
            .foregroundColor(.white)
            .widgetURL(URL(string: "MindNotes//NewThoughtView"))
//
       
//            Spacer()
//            
//            Text("Novo Pensamento")
//                .font(.caption)
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
        .containerBackground(for: .widget) {
//            LinearGradient(
//                colors: [Color.primary.opacity(0.8), Color.secondary.opacity(0.8)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
            Color.black.opacity(0.85)
        }
    }
}

#Preview(as: .systemSmall) {
    MindNotesWidget()
} timeline: {
    MindNotesTimelineEntry(date: .now)
} 

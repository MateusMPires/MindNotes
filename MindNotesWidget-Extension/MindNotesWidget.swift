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
        .supportedFamilies([.systemSmall]) // Specify small Lock Screen families

    }
}

struct MindNotesWidgetView: View {
    var entry: MindNotesTimelineEntry
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Sequência")
                    .font(.custom("Outfit-Regular", size: 12))
                //.bold()
                    
                
                Spacer()
                
                Image(systemName: "brain.fill")
                    .font(.system(size: 16))
            }
            //.padding(.top)
            
            VStack(spacing: -8) {
                Text("2")
                    .font(.custom("Manrope-Regular", size: 50))
                    .bold()
                    .contentTransition(.numericText())
                
                Text("Dias")
                    .font(.custom("Outfit-Regular", size: 12))
                    .bold()

            }
            
//            Button {
//                // Deep link será tratado pelo widgetURL
//
//            } label: {
//                Label("Nova entrada", systemImage: "square.and.pencil")
//                   
//
//            }
            
            //.frame(maxWidth: .infinity)
            //.font(.system(size: 12).bold())
                 //               .background(.white)
            //.foregroundColor(.white)
            .widgetURL(URL(string: "mindnotes://new-thought"))
//
       
            Spacer()
//            
//            Text("Novo Pensamento")
//                .font(.caption)
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(.yellow)
        .widgetURL(URL(string: "mindnotes://open-app"))
        .foregroundColor(.white)
        .containerBackground(for: .widget) {
//            LinearGradient(
//                colors: [Color.primary.opacity(0.8), Color.secondary.opacity(0.8)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
            //Color("#131313").ignoresSafeArea()
            Color.widgetBackground
        }
    }
}

#Preview(as: .systemSmall) {
    MindNotesWidget()
} timeline: {
    MindNotesTimelineEntry(date: .now)
} 

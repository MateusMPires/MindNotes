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
        .description("sequência")
        .supportedFamilies([.systemSmall]) // Specify small Lock Screen families

    }
}

struct MindNotesWidgetView: View {
    var entry: MindNotesTimelineProvider.Entry
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Sequência")
                    .font(.custom("Outfit-Medium", size: 12))
                //.bold()
                    
                
                Spacer()
                
                Image("Button")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 16))
            }
            //.padding(.top)
            
            VStack(spacing: -8) {
                Text("\(entry.streak)")
                    .font(.custom("Manrope-Regular", size: 50))
                    .bold()
                    .contentTransition(.numericText())
                
                Text("Dias")
                    .font(.custom("Outfit-Regular", size: 12))
                    .bold()

            }
 
            .widgetURL(URL(string: "mindnotes://new-thought"))
       
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("PrimaryColor"))
        .containerBackground(for: .widget) {
            Color.white
            LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 17/255, green: 47/255, blue: 58/255),
                        Color(red: 21/255, green: 54/255, blue: 65/255),
                        Color(red: 34/255, green: 74/255, blue: 88/255),
                        Color(red: 47/255, green: 94/255, blue: 111/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            .opacity(0.1)
            
        }
    }
}

#Preview(as: .systemSmall) {
    MindNotesWidget()
} timeline: {
    MindNotesTimelineEntry(date: .now, streak: 2)
} 

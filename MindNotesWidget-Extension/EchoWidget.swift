//
//  Untitled.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 27/08/25.
//

import WidgetKit
import SwiftUI

// MARK: - Entry
struct EchoEntry: TimelineEntry {
    var date: Date
    var echo: String
}

// MARK: - Provider
struct EchoProvider: TimelineProvider {
    func placeholder(in context: Context) -> EchoEntry {
        EchoEntry(date: Date(), echo: "Frase marcada como eco.")
    }

    func getSnapshot(in context: Context, completion: @escaping (EchoEntry) -> ()) {
        let entry = EchoEntry(date: Date(), echo: "Frase marcada como eco.")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<EchoEntry>) -> ()) {
        
        var entry: EchoEntry = EchoEntry(date: Date(), echo: "")

        if let userDefaults = UserDefaults(suiteName: "group.mindNotes") {
            let echo = userDefaults.string(forKey: "ecoPhrase") ?? "Sem eco definido ainda."
            let date = userDefaults.object(forKey: "ecoPhraseLastUpdated") as? Date ?? .distantPast
            
            entry.echo = echo
            entry.date = date
        }
      
        
        // Atualiza de hora em hora
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

// MARK: - View
struct EchoWidgetView: View {
    var entry: EchoEntry
    
    var body: some View {
        
            VStack {
                HStack {
                    Text("ecos")
                        .font(.custom("Outfit-Medium", size: 12))
                    
                    Image(systemName: "wave.3.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.accent)
                    
                    Spacer()
                    
                    Image("Button")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text(entry.echo)
                        .font(.custom("Manrope-SemiBold", size: 16))
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("11 de agosto")
                        .font(.custom("Manrope-Regular", size: 10))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
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
            .foregroundColor(Color("PrimaryColor"))
    }
}

// MARK: - Widget
struct EchoWidget: Widget {
    let kind: String = "Echo_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: EchoProvider(),
            content: { entry in
                EchoWidgetView(entry: entry)
            }
        )
        .configurationDisplayName("Ecos")
        .description("Mostra frases marcadas como ecos.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    EchoWidget()
} timeline: {
    EchoEntry(date: Date(), echo: "Atenção é a forma máxima de respeito.")
}

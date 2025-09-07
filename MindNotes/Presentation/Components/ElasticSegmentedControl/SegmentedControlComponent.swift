//
//  SwiftUIView.swift
//  Kavsoft_Learning
//
//  Created by Mateus Martins Pires on 12/03/24.
//

import SwiftUI
import SwiftData

struct ContentElasticCustomSegmentedControl: View {
    // View Properties
    @State private var activeTab: SegmentedTab = .favourites
    @State private var type2: Bool = false
    
    var body: some View {
            VStack(spacing: 15) {
                ElasticCustomSegmentedControl(
                    tabs: SegmentedTab.allCases,
                    activeTab: $activeTab,
                    height: 35,
                    font: .callout,
                    activeTint: type2 ? .white : .primary,
                    inActiveTint: .gray.opacity(0.5)
                ) { size in
                    RoundedRectangle(cornerRadius: type2 ? 30 : 0)
                        .fill(.accent)
                        .frame(height: type2 ? size.height : 4)
                        .padding(.horizontal, 10)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .padding(.top, type2 ? 0 : 10)
                // Type 2 Segmented Control background
//                .background {
//                    RoundedRectangle(cornerRadius: type2 ? 30 : 0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
//                        .fill(.ultraThinMaterial)
//                        .ignoresSafeArea()
//                }
                .padding(.horizontal, type2 ? 15 : 100)
                
            }
            .padding(.vertical, type2 ? 15 : 0)
            .animation(.snappy, value: type2)
            .toolbarBackground(.hidden, for: .navigationBar)
        
    }
}

// MARK: - Preview
#Preview {
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    ThoughtsContentView()
        .modelContainer(sharedModelContainer)
        .environmentObject(JourneyService(context: sharedModelContainer.mainContext))
        .environmentObject(ThoughtService(context: sharedModelContainer.mainContext))
}
    


// Enum to define the segmented control icons
enum SegmentedTab: String, CaseIterable {
    
    case favourites = "list.bullet"
    case notifications = "circle.dashed"
//    case profile = "person.fill"

}

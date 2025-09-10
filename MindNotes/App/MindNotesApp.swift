//
//  MindNotesApp.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 15/07/25.
//

import SwiftUI
import SwiftData
import AppIntents

@main
struct MindNotesApp: App {
    
    // SwiftData Container...
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema(versionedSchema: SchemaV1.self)
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)

        do {
            return try ModelContainer(
                for: schema, // versão atual
                migrationPlan: MigrationPlan.self // plano de migração
            )
        } catch {
            fatalError("Falha ao inicializar ModelContainer: \(error)")
        }
    }()
    
    // Services...
    var thoughtService: ThoughtService
    var journeyService: JourneyService
    
    // Onboarding @AppStorage...
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    
    init() {
        let modelContext = sharedModelContainer.mainContext
        
        self.thoughtService = ThoughtService(context: modelContext)
        self.journeyService = JourneyService(context: modelContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(thoughtService)
                .environmentObject(journeyService)
        }
        .modelContainer(sharedModelContainer)
        
        //            .sheet(isPresented: $showingWelcome) {
        //                WelcomeView()
        //            }
        //            .onAppear {
        //                if !hasSeenWelcome {
        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                        showingWelcome = true
        //                        hasSeenWelcome = true
        //                    }
        //                }
        //            }
        //        }
    }
}

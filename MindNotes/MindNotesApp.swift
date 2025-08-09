//
//  MindNotesApp.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 15/07/25.
//

import SwiftUI
import SwiftData

@main
struct MindNotesApp: App {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .modelContainer(dataManager.container)
                .onAppear {
                    Task { @MainActor in
                        dataManager.setupDefaultJourneys()
                    }
                }
        }
    }
}

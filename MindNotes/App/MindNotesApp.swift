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
    
    // 1.
    @State var linkActive = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(dataManager)
                    .modelContainer(dataManager.container)
                    .onAppear {
                        Task { @MainActor in
                            dataManager.setupDefaultJourneys()
                        }
                    }
                // 3.
                    .onOpenURL { url in
                        print("Received deep link: \(url)")
                        linkActive = true
                    }
                // 4.
                    .sheet(isPresented: $linkActive) {
                        NewThoughtView()
//                            .environmentObject(thoughtViewModel)
                    }
            }
        }
    }
}

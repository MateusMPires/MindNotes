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
    
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    
    @Query(sort: \Journey.createdDate) private var journeys: [Journey]
    
    @State var linkActive = false
    @State private var showingWelcome = false
    
    var body: some Scene {
        WindowGroup {
           // NavigationStack {
            ContentView(journeys: journeys)
                    .onOpenURL { url in
                        print("Received deep link: \(url)")
                        
                        if url.host == "open-app" {
                            
                            linkActive = true
                        } else {
                            
                        }
                        
                    }
                    .sheet(isPresented: $linkActive) {
                        NewThoughtView(journeys: journeys)
                    }
            }
        .modelContainer(for: [Journey.self, Thought.self])

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

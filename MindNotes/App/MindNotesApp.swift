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
    
    @State var linkActive = false
    
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @State private var showingWelcome = false

//    init() {
//        let appear = UINavigationBarAppearance()
//
//        let atters: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "Outfit-Regular", size: 36)!
//        ]
//
//        appear.backgroundColor = UIColor(Color(hex: "#131313"))
//
//        appear.largeTitleTextAttributes = atters
//        appear.titleTextAttributes = atters
//        UINavigationBar.appearance().standardAppearance = appear
//        UINavigationBar.appearance().compactAppearance = appear
//        UINavigationBar.appearance().scrollEdgeAppearance = appear
//     }
    
    var body: some Scene {
        WindowGroup {
           // NavigationStack {
                ContentView()
                    .onOpenURL { url in
                        print("Received deep link: \(url)")
                        
                        if url.host == "open-app" {
                            
                            linkActive = true
                        } else {
                            
                        }
                        
                    }
                    .sheet(isPresented: $linkActive) {
                        NewThoughtView()
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

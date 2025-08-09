//
//  ContentView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 15/07/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataManager: DataManager
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @State private var showingWelcome = false
    @StateObject private var thoughtViewModel = ThoughtViewModel()
    

    var body: some View {
        TodayView()
            .environmentObject(thoughtViewModel)
            .environmentObject(dataManager)
            .sheet(isPresented: $showingWelcome) {
                WelcomeView()
            }
            .onAppear {
                if !hasSeenWelcome {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showingWelcome = true
                        hasSeenWelcome = true
                    }
                }
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager.shared)
}

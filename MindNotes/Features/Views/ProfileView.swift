//
//  ProfileView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var journeysCount: Int = 0
    @State private var thoughtsCount: Int = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 56, height: 56)
                            .overlay(Image(systemName: "person").foregroundColor(.primary))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Você")
                                .font(.headline)
                            Text("MindNotes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Resumo") {
                    HStack { Text("Jornadas"); Spacer(); Text("\(journeysCount)").foregroundColor(.secondary) }
                    HStack { Text("Pensamentos"); Spacer(); Text("\(thoughtsCount)").foregroundColor(.secondary) }
                }
            }
            .navigationTitle("Perfil")
            .onAppear {
                journeysCount = dataManager.fetchJourneys(includeArchived: true).count
                thoughtsCount = dataManager.fetchThoughts().count
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(DataManager.shared)
}


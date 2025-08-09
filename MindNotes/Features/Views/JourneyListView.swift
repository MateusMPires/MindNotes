//
//  JourneyListView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

struct JourneyListView: View {
    @StateObject private var journeyViewModel = JourneyViewModel()
    @EnvironmentObject private var thoughtViewModel: ThoughtViewModel
    @State private var showingCreateJourney = false
    @State private var selectedJourney: Journey?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        ThoughtListView(journey: nil)
                            .environmentObject(thoughtViewModel)
                    } label: {
                        HStack {
                            Image(systemName: "tray.full.fill")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .frame(width: 32, height: 32)
                                .background(Color.secondary.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("minha mente")
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                Text("\(thoughtViewModel.thoughts.count) pensamentos")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    
                    NavigationLink {
                        ThoughtListView(journey: nil, favoritesOnly: true)
                            .environmentObject(thoughtViewModel)
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .frame(width: 32, height: 32)
                                .background(Color.secondary.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("favoritos")
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text("\(thoughtViewModel.thoughts.filter(\.isFavorite).count) pensamentos")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                
                Section("Jornadas") {
                    ForEach(journeyViewModel.journeys) { journey in
                        NavigationLink {
                            ThoughtListView(journey: journey)
                                .environmentObject(thoughtViewModel)
                        } label: {
                            JourneyRowView(journey: journey)
                        }
                        .contextMenu {
                            Button {
                                selectedJourney = journey
                                showingCreateJourney = true
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            Button {
                                journeyViewModel.archiveJourney(journey)
                            } label: {
                                Label("Arquivar", systemImage: "archivebox")
                            }
                            Button(role: .destructive) {
                                journeyViewModel.deleteJourney(journey)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: deleteJourneys)
                    
                    Button {
                        showingCreateJourney = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.primary)
                                .font(.title2)
                            Text("Nova Jornada")
                                .foregroundColor(.primary)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                if journeyViewModel.showingArchived {
                    Section("Arquivadas") {
                        ForEach(journeyViewModel.journeys.filter(\.isArchived)) { journey in
                            NavigationLink {
                                ThoughtListView(journey: journey)
                                    .environmentObject(thoughtViewModel)
                            } label: {
                                JourneyRowView(journey: journey)
                            }
                            .contextMenu {
                                Button {
                                    journey.isArchived = false
                                    journeyViewModel.updateJourney(journey)
                                } label: {
                                    Label("Desarquivar", systemImage: "tray.and.arrow.up")
                                }
                                Button(role: .destructive) {
                                    journeyViewModel.deleteJourney(journey)
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("jornadas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingCreateJourney = true
                        } label: {
                            Label("Nova Jornada", systemImage: "folder.badge.plus")
                        }
                        Button {
                            journeyViewModel.toggleArchivedView()
                        } label: {
                            Label(
                                journeyViewModel.showingArchived ? "Ocultar Arquivadas" : "Mostrar Arquivadas",
                                systemImage: journeyViewModel.showingArchived ? "eye.slash" : "eye"
                            )
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingCreateJourney) {
                CreateJourneyView(
                    journeyViewModel: journeyViewModel,
                    journey: selectedJourney
                )
                .onDisappear { selectedJourney = nil }
            }
            .onAppear {
                journeyViewModel.loadJourneys()
                thoughtViewModel.loadThoughts()
            }
        }
    }
    
    private func deleteJourneys(offsets: IndexSet) {
        for index in offsets {
            journeyViewModel.deleteJourney(journeyViewModel.journeys[index])
        }
    }
}

struct JourneyRowView: View {
    let journey: Journey
    
    var body: some View {
        HStack {
            Text(journey.emoji)
                .font(.title2)
                .frame(width: 32, height: 32)
                .background(Color.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                Text(journey.name)
                    .font(.body)
                    .fontWeight(.medium)
                Text("\(journey.thoughtCount) pensamentos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if journey.isArchived {
                Image(systemName: "archivebox.fill")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    JourneyListView()
        .environmentObject(ThoughtViewModel())
}

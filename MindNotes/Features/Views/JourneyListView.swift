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
    @StateObject private var thoughtViewModel = ThoughtViewModel()
    @State private var showingCreateJourney = false
    @State private var selectedJourney: Journey?
    
    var body: some View {
        NavigationStack {
            List {
                // All Thoughts Section
                Section {
                    NavigationLink {
                        ThoughtListView(journey: nil)
                            .environmentObject(thoughtViewModel)
                    } label: {
                        HStack {
                            Image(systemName: "tray.full.fill")
                                .foregroundColor(.white)
                                .font(.title3)
                                .frame(width: 32, height: 32)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Todos os Pensamentos")
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
                                .foregroundColor(.white)
                                .font(.title3)
                                .frame(width: 32, height: 32)
                                .background(Color.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Favoritos")
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
                
                // Journeys Section
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
                                .foregroundColor(.blue)
                                .font(.title2)
                            
                            Text("Nova Jornada")
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                // Archived Journeys Section
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
            .navigationTitle("MindNotes")
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
                    }
                }
            }
            .sheet(isPresented: $showingCreateJourney) {
                CreateJourneyView(
                    journeyViewModel: journeyViewModel,
                    journey: selectedJourney
                )
                .onDisappear {
                    selectedJourney = nil
                }
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
                .background(Color(hex: journey.colorHex).opacity(0.2))
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
}
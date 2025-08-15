//
//  JourneyListView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

// GalleryView...
struct GalleryJourneyView: View {
    
    //SwiftData...
    @Query(sort: \Journey.createdDate, order: .reverse) private var journeys: [Journey]
    @Environment(\.modelContext) private var context

    
    @StateObject private var journeyViewModel = JourneyViewModel()
    
    @Binding var showJourneyView: Bool

    @State private var addNewJourney = false
    @State private var selectedJourney: Journey?
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        NavigationLink {
                            DetailedJourneyView(allThoughts: true, journey: nil)
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
                                }
                                Spacer()
                            }
                        }
                        .listRowBackground( Color.clear
                        )
                        .listRowSeparator(.hidden)
                    }
                    
                    //                Section("Jornadas") {
                    //                    if !journeys.isEmpty {
                    //                        ForEach(journeys) { journey in
                    //                            NavigationLink {
                    //                                // Thoughts for that Journey...
                    //                                //ThoughtListView(journey: journey)
                    //                                DetailedJourneyView(journey: journey)
                    //                            } label: {
                    //                                JourneyRowView(journey: journey)
                    //                            }
                    //                            .contextMenu {
                    //                                Button {
                    //                                    selectedJourney = journey
                    //                                    //showingCreateJourney = true
                    //                                } label: {
                    //                                    Label("Editar", systemImage: "pencil")
                    //                                }
                    //                                Button {
                    //                                    journeyViewModel.archiveJourney(journey)
                    //                                } label: {
                    //                                    Label("Arquivar", systemImage: "archivebox")
                    //                                }
                    //                                Button(role: .destructive) {
                    //                                    journeyViewModel.deleteJourney(journey)
                    //                                } label: {
                    //                                    Label("Excluir", systemImage: "trash")
                    //                                }
                    //                            }
                    //                            .swipeActions(edge: .trailing) {
                    //                                Button {
                    //                                    context.delete(journey)
                    //                                } label: {
                    //                                    Image(systemName: "trash.fill")
                    //                                }
                    //                            }
                    //                        }
                    //
                    //                        Button {
                    //                            addNewJourney = true
                    //                        } label: {
                    //                            HStack {
                    //                                Image(systemName: "plus.circle.fill")
                    //                                    .foregroundColor(.primary)
                    //                                    .font(.title2)
                    //                                Text("Nova Jornada")
                    //                                    .foregroundColor(.primary)
                    //                                    .fontWeight(.medium)
                    //                            }
                    //                        }
                    //                    } else {
                    //                        Text("Sem jornadas cadastradas...")
                    //                    }
                    //                }
                    
                    //                if journeyViewModel.showingArchived {
                    //                    Section("Arquivadas") {
                    //                        ForEach(journeyViewModel.journeys.filter(\.isArchived)) { journey in
                    //                            NavigationLink {
                    //                               // ThoughtListView(journey: journey)
                    //                               //     .environmentObject(thoughtViewModel)
                    //                            } label: {
                    //                                JourneyRowView(journey: journey)
                    //                            }
                    //                            .contextMenu {
                    //                                Button {
                    //                                    journey.isArchived = false
                    //                                    journeyViewModel.updateJourney(journey)
                    //                                } label: {
                    //                                    Label("Desarquivar", systemImage: "tray.and.arrow.up")
                    //                                }
                    //                                Button(role: .destructive) {
                    //                                    journeyViewModel.deleteJourney(journey)
                    //                                } label: {
                    //                                    Label("Excluir", systemImage: "trash")
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    //                }
                    
                }
                .listStyle(.plain)
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 20)
                .navigationTitle("jornadas")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showJourneyView.toggle()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundStyle(.secondary)
                        
                        //                    Menu {
                        //                        Button {
                        //                            showingCreateJourney = true
                        //                        } label: {
                        //                            Label("Nova Jornada", systemImage: "folder.badge.plus")
                        //                        }
                        //                        Button {
                        //                            journeyViewModel.toggleArchivedView()
                        //                        } label: {
                        //                            Label(
                        //                                journeyViewModel.showingArchived ? "Ocultar Arquivadas" : "Mostrar Arquivadas",
                        //                                systemImage: journeyViewModel.showingArchived ? "eye.slash" : "eye"
                        //                            )
                        //                        }
                        //                    } label: {
                        //                        Image(systemName: "ellipsis.circle")
                        //                            .foregroundColor(.primary)
                        //                    }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button{
                                // NewJourney...
                                addNewJourney = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                Text("Adicionar jornada")
                            }
                            .bold()
                            
                            Spacer()
                        }
                    }
                }
//                .toolbar(content: {
//                    ToolbarItem(placement: .bottomBar) {
//                        HStack {
//                            Button{
//                                // NewJourney...
//                                addNewJourney = true
//                            } label: {
//                                Image(systemName: "plus.circle.fill")
//                                Text("Adicionar jornada")
//                            }
//                            .bold()
//                            
//                            Spacer()
//                        }
//                    }
//                })
                .sheet(isPresented: $addNewJourney) {
                    CreateJourneyView(
                        journeyViewModel: journeyViewModel,
                        journey: selectedJourney
                    )
                    .onDisappear { selectedJourney = nil }
                }
            }
        }
        .background(   Color.clear.ignoresSafeArea())
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
    GalleryJourneyView(showJourneyView: .constant(true))
        .modelContainer(for: Journey.self, inMemory: true)
//        .environmentObject(ThoughtViewModel())
}

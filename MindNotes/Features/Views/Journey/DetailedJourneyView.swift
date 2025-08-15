//
//  ThoughtListView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

struct DetailedJourneyView: View {
    
    // SwiftData
     @Environment(\.modelContext) private var context
     @Query private var allThoughtsQuery: [Thought]
     
     let allThoughts: Bool?
     let journey: Journey?
       
     @State private var showingNewThought = false
     @State private var searchText = ""
     @State private var selectedThought: Thought?
     @State private var showingTagFilter = false
     
     // Computed properties para melhor performance
     private var thoughtsToShow: [Thought] {
         if allThoughts == true {
             return filteredThoughts(from: allThoughtsQuery)
         } else {
             return filteredThoughts(from: journey?.thoughts ?? [])
         }
     }
     
     private var navigationTitle: String {
         if allThoughts == true {
             return "minha mente"
         } else {
             return journey?.name ?? "Pensamentos"
         }
     }
     
     private var isEmpty: Bool {
         thoughtsToShow.isEmpty
     }
     
     var body: some View {
         NavigationStack {
             Group {
                 if isEmpty && searchText.isEmpty {
                     emptyStateView
                 } else {
                     thoughtListContent
                 }
             }
             .navigationTitle(navigationTitle)
             .navigationBarTitleDisplayMode(.inline)
             .searchable(text: $searchText, prompt: "Buscar pensamentos...")
             .toolbar {
                 toolbarContent
             }
             .sheet(isPresented: $showingNewThought) {
                 NewThoughtView()
             }
             .sheet(isPresented: $showingTagFilter) {
                 TagFilterView()
             }
             .background(Color(hex: "#131313").ignoresSafeArea())
         }
     }
     
     // MARK: - Content Views
     @ViewBuilder
     private var thoughtListContent: some View {
         List {
             if !thoughtsToShow.isEmpty {
                 thoughtsSection
             } else {
                 noResultsSection
             }
         }
         .listStyle(.plain)


     }
     
     private var thoughtsSection: some View {
         Section {
             LazyVStack {
                 ForEach(thoughtsToShow) { thought in
                     ThoughtRowView(thought: thought)
                         .swipeActions(edge: .leading) {
                             Button {
                                 deleteThought(thought)
                                 
                             } label: {
                                 Image(systemName: "bell.fill")
                                     .font(.system(size: 32, weight: .semibold))
                                     .foregroundStyle(.red)
                             }
                             .tint(.clear)
                         }
                         .swipeActions(edge: .trailing) {
                             // Botão excluir
                             Button {
                                 deleteThought(thought)
                                 
                             } label: {
                                 Image(systemName: "trash")
                                     .font(.system(size: 32, weight: .semibold))
                                     .foregroundStyle(.red)
                             }
                             .tint(.clear)
                             
                             
                             Button {
                                 //thoughtViewModel.toggleFavorite(thought)
                             } label: {
                                 Image(systemName: "pencil")
                             }
                             .tint(.clear)
                             .clipShape(Circle())
                         }
                 }
                .padding(.vertical, 8)
             }
             .listRowBackground(Color.clear)
             .listRowSeparator(Visibility.hidden, edges: .all)
             
         } header: {
             if !searchText.isEmpty {
                 Text("\(thoughtsToShow.count) resultado(s)")
             } else {
                 Text(sectionTitle)
             }
         }
     }
     
     private var noResultsSection: some View {
         Section {
             HStack {
                 Spacer()
                 VStack(spacing: 8) {
                     Image(systemName: "magnifyingglass")
                         .font(.title2)
                         .foregroundColor(.secondary)
                     Text("Nenhum resultado encontrado")
                         .font(.callout)
                         .foregroundColor(.secondary)
                 }
                 Spacer()
             }
             .padding(.vertical)
         }
     }
     
     private var emptyStateView: some View {
         VStack(spacing: 20) {
             Image(systemName: "brain.head.profile")
                 .font(.system(size: 60))
                 .foregroundColor(.gray)
             
             VStack(spacing: 8) {
                 Text("Nenhum pensamento ainda")
                     .font(.title2)
                     .fontWeight(.medium)
                 
                 Text("Comece adicionando seu primeiro pensamento")
                     .font(.callout)
                     .foregroundColor(.secondary)
                     .multilineTextAlignment(.center)
             }
             
             Button("Adicionar Pensamento") {
                 showingNewThought = true
             }
             .buttonStyle(.borderedProminent)
         }
         .padding()
         .frame(maxWidth: .infinity, maxHeight: .infinity)
     }
     
     // MARK: - Toolbar
     @ToolbarContentBuilder
     private var toolbarContent: some ToolbarContent {
         if journey != nil {
             ToolbarItem(placement: .navigationBarTrailing) {
                 journeyMenuButton
             }
         }
         
//         ToolbarItem(placement: .bottomBar) {
//             addThoughtButton
//         }
     }
     
     private var filterButton: some View {
         Menu {
             Button {
                 showingTagFilter = true
             } label: {
                 Label("Filtrar por Tags", systemImage: "tag")
             }
             
             Button {
                 searchText = ""
             } label: {
                 Label("Limpar Busca", systemImage: "xmark.circle")
             }
             .disabled(searchText.isEmpty)
         } label: {
             Image(systemName: "line.3.horizontal.decrease.circle")
                 .foregroundColor(.blue)
         }
     }
     
     private var journeyMenuButton: some View {
         Menu {
             Button {
                 // Edit Journey
             } label: {
                 Label("Editar Jornada", systemImage: "pencil")
             }
             
             Button {
                 // Archive Journey
                 archiveJourney()
             } label: {
                 Label(
                     journey?.isArchived == true ? "Desarquivar" : "Arquivar",
                     systemImage: "archivebox"
                 )
             }
             
             Divider()
             
             Button(role: .destructive) {
                 deleteJourney()
             } label: {
                 Label("Excluir Jornada", systemImage: "trash")
             }
         } label: {
             Image(systemName: "ellipsis.circle")
                 .foregroundColor(.blue)
         }
     }
     
     private var addThoughtButton: some View {
         HStack {
             Button {
                 showingNewThought = true
             } label: {
                 HStack {
                     Image(systemName: "plus.circle.fill")
                     Text("Novo Pensamento")
                 }
             }
             .foregroundColor(.blue)
             .fontWeight(.medium)
             
             Spacer()
         }
     }
     
     // MARK: - Helper Methods
     private func filteredThoughts(from thoughts: [Thought]) -> [Thought] {
         let filtered = thoughts.filter { thought in
             if searchText.isEmpty {
                 return true
             }
             
             return thought.content.localizedCaseInsensitiveContains(searchText) ||
                    thought.notes?.localizedCaseInsensitiveContains(searchText) == true ||
                    thought.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
         }
         
         // Ordenar por data de modificação (mais recente primeiro)
         return filtered.sorted { $0.modifiedDate > $1.modifiedDate }
     }
     
     private var sectionTitle: String {
         let formatter = DateFormatter()
         formatter.dateFormat = "MMMM yyyy"
         formatter.locale = Locale(identifier: "pt_BR")
         return formatter.string(from: Date())
     }
     
     // MARK: - Actions
     private func deleteThought(_ thought: Thought) {
         withAnimation {
             context.delete(thought)
             try? context.save()
         }
     }
     
     private func toggleFavorite(_ thought: Thought) {
         withAnimation {
             thought.isFavorite.toggle()
             thought.updateModifiedDate()
             try? context.save()
         }
     }
     
     private func shareThought(_ thought: Thought) {
         // Implementar compartilhamento
         let shareText = """
         💭 \(thought.content)
         
         \(thought.notes ?? "")
         
         📅 \(thought.createdDate.formatted(date: .abbreviated, time: .shortened))
         """
         
         // Aqui você pode usar UIActivityViewController ou similar
         print("Compartilhando: \(shareText)")
     }
     
     private func archiveJourney() {
         guard let journey = journey else { return }
         
         withAnimation {
             journey.isArchived.toggle()
             try? context.save()
         }
     }
     
     private func deleteJourney() {
         guard let journey = journey else { return }
         
         withAnimation {
             context.delete(journey)
             try? context.save()
         }
     }
 }



struct TagFilterRowView: View {
    @EnvironmentObject private var thoughtViewModel: ThoughtViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filtros Ativos")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(thoughtViewModel.selectedTags), id: \.self) { tag in
                        HStack(spacing: 4) {
                            Text("#\(tag)")
                                .font(.caption)
                            
                            Button {
                                thoughtViewModel.toggleTag(tag)
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.caption2)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                    }
                    
                    Button {
                        thoughtViewModel.clearTagFilters()
                    } label: {
                        Text("Limpar Tudo")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .overlay(
                                Capsule()
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Thought.self, inMemory: true)
}

#Preview {
    DetailedJourneyView(allThoughts: true, journey: Journey(name: "Criativo"))
        .modelContainer(for: [Journey.self, Thought.self], inMemory: true)
}

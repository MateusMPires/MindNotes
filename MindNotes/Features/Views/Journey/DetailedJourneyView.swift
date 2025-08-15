//
//  ThoughtListView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

struct DetailedJourneyView: View {
    
    @Environment(\.modelContext) private var context
    let journey: Journey?
//
    //@Query(filter: #Predicate { $0.journeyId == journey.id }) var thoughts: [Thought]

//
//      init(journey: Journey) {
//          self.journey = journey
//          
//          // Predicate para filtrar pensamentos da jornada
//          let predicate = Predicate<Thought> { $0.journeyId == journey.id }
//
//          // Inicializa o Query com filtro e ordena pela data de criação
//          _thoughts = Query(filter: predicate, sort: \.createdDate, order: .forward)
//      }
      
    
    let favoritesOnly: Bool
    
    @EnvironmentObject private var thoughtViewModel: ThoughtViewModel
    @State private var showingNewThought = false
    @State private var searchText = ""
    @State private var selectedThought: Thought?
    @State private var showingTagFilter = false
    
    init(journey: Journey? = nil, favoritesOnly: Bool = false) {
        self.journey = journey
        self.favoritesOnly = favoritesOnly
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if thoughtViewModel.filteredThoughts.isEmpty {
                    emptyStateView
                } else {
                    thoughtsList
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Buscar pensamentos...")
            .onChange(of: searchText) { _, newValue in
                thoughtViewModel.searchThoughts(query: newValue)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            thoughtViewModel.toggleFavoritesOnly()
                        } label: {
                            Label(
                                thoughtViewModel.showingFavoritesOnly ? "Mostrar Todos" : "Apenas Favoritos",
                                systemImage: thoughtViewModel.showingFavoritesOnly ? "star.slash" : "star"
                            )
                        }
                        
                        Button {
                            showingTagFilter = true
                        } label: {
                            Label("Filtrar por Tags", systemImage: "tag")
                        }
                        
                        if !thoughtViewModel.selectedTags.isEmpty {
                            Button {
                                thoughtViewModel.clearTagFilters()
                            } label: {
                                Label("Limpar Filtros", systemImage: "xmark.circle")
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
//                ToolbarItem(placement: .bottomBar) {
//                    HStack {
//                        Button {
//                            showingNewThought = true
//                        } label: {
//                            HStack {
//                                Image(systemName: "plus.circle.fill")
//                                Text("Novo Pensamento")
//                            }
//                            .foregroundColor(.blue)
//                            .fontWeight(.medium)
//                        }
//                        
//                        Spacer()
//                        
//                        if !thoughtViewModel.selectedTags.isEmpty {
//                            Text("\(thoughtViewModel.selectedTags.count) filtros")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
            }
            .sheet(isPresented: $showingNewThought) {
                NewThoughtView(journey: journey)
                    .environmentObject(thoughtViewModel)
            }
            .sheet(isPresented: $showingTagFilter) {
                TagFilterView()
                    .environmentObject(thoughtViewModel)
            }
            .onAppear {
                thoughtViewModel.setJourney(journey)
                if favoritesOnly {
                    thoughtViewModel.showingFavoritesOnly = true
                }
                thoughtViewModel.loadThoughts()
            }
        }
    }
    
    private var navigationTitle: String {
        if favoritesOnly {
            return "Favoritos"
        } else if let journey = journey {
            return journey.name
        } else {
            return "Todos os Pensamentos"
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: journey == nil ? "tray" : "folder")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("Nenhum pensamento")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(emptyStateMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button {
                showingNewThought = true
            } label: {
                Text("Criar Primeiro Pensamento")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
    }
    
    private var emptyStateMessage: String {
        if favoritesOnly {
            return "Você ainda não tem pensamentos favoritos."
        } else if journey != nil {
            return "Esta jornada ainda não tem pensamentos. Comece registrando suas reflexões."
        } else {
            return "Comece sua jornada de autoconhecimento registrando seus primeiros pensamentos."
        }
    }
    
    private var thoughtsList: some View {
        List {
            if !thoughtViewModel.selectedTags.isEmpty {
                Section {
                    TagFilterRowView()
                        .environmentObject(thoughtViewModel)
                }
            }
            
            ForEach(thoughtViewModel.sortedMonthKeys, id: \.self) { monthKey in
                if let monthThoughts = thoughtViewModel.thoughtsByMonth[monthKey], !monthThoughts.isEmpty {
                    Section(monthKey) {
                        ForEach(monthThoughts) { thought in
                            NavigationLink {
                                DetailedThoughtView(thought: thought)
                                    .environmentObject(thoughtViewModel)
                            } label: {
                                ThoughtRowView(thought: thought)
                                    .environmentObject(thoughtViewModel)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    thoughtViewModel.deleteThought(thought)
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    thoughtViewModel.toggleFavorite(thought)
                                } label: {
                                    Label(
                                        thought.isFavorite ? "Desfavoritar" : "Favoritar",
                                        systemImage: thought.isFavorite ? "star.slash" : "star"
                                    )
                                }
                                .tint(.yellow)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    shareThought(thought)
                                } label: {
                                    Label("Compartilhar", systemImage: "square.and.arrow.up")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func shareThought(_ thought: Thought) {
        let text = thought.content
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }
}

struct ThoughtRowView: View {
    let thought: Thought
    @EnvironmentObject private var thoughtViewModel: ThoughtViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(thought.content)
                        .font(.body)
                        .lineLimit(3)
                    
                    if let notes = thought.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if thought.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    
                    if thought.shouldRemind {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                            .font(.caption2)
                    }
                }
            }
            
            HStack {
                if !thought.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(thought.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
                
                Spacer()
                
                Text(formatDate(thought.createdDate))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
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
    DetailedJourneyView()
        .environmentObject(ThoughtViewModel())
}

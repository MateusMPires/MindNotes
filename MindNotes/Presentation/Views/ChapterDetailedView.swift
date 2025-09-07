//
//  ThoughtListView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

// Preciso de: Todos os pensamentos de uma jornada específica..
// Fazer funções Void para editar, deletar e compartilhar.


struct ChapterDetailedView: View {
    
    // View...
    @Environment(\.dismiss) private var dismiss

    // Info...
    let chapterTitle: String
    let chapterDescription: String?
    let chapterIcon: String
    let chapterHex: String
    let chapterStartDate: Date?
    let isArchived: Bool
    let thoughts: [Thought]
    let showBanner: Bool
    
    // Closures que são resolvidas pela GalleryView
    var onEdit: (() -> Void)?
    
    var onArchive: (() -> Void)?
    
    var onDelete: (() -> Void)?
        
    // Searching...
     @State private var searchText = ""
     @State private var selectedThought: Thought?
     @State private var showingTagFilter = false

    // Confirmation dialogs
       @State private var showingArchiveConfirmation = false
       @State private var showingDeleteConfirmation = false

     
     private var isEmpty: Bool {
         thoughts.isEmpty
     }
     
     var body: some View {
         ZStack {
             
             AppBackground()
             
             VStack(spacing: 64) {
                 
                 VStack(spacing: 8){
//                     Circle()
//                         .frame(width: 32, height: 32)
//                         .foregroundStyle(Color(hex: chapterHex))
                     
                     Image(systemName: chapterIcon)
                         .font(.system(size: 16))
                         .foregroundStyle(.white)
                         .padding(10)
                         //.frame(width: 32, height: 32)
                         .background(Color(hex: chapterHex))
                         .clipShape(Circle())
                     
                     VStack(spacing: 4){
                         Text("\(chapterTitle).")
                             .textCase(.lowercase)
                             .font(DesignTokens.Typography.title)
                         
                         Text("criado em 25 ago 2025")
                             .font(DesignTokens.Typography.caption)
                             .foregroundStyle(.secondary)
                     }
                 }
                 
                 Group {
                     if isEmpty && searchText.isEmpty {
                         emptyStateView
                     } else {
                         thoughtListContent
                     }
                 }
             }
             .navigationDestination(item: $selectedThought) { thought in
                 ThoughtDetailedView(thought: thought)
             }
             .navigationBarBackButtonHidden()
             //.searchable(text: $searchText, prompt: "Buscar pensamentos...")
             .toolbar {
                 toolbarContent
             }
//             .sheet(isPresented: $showingTagFilter) {
//                 TagsView(selectedTags: $selectedTags)
//             }
             .confirmationDialog(
                  isArchived ? "Desarquivar Capítulo" : "Arquivar Capítulo",
                  isPresented: $showingArchiveConfirmation,
                  titleVisibility: .visible
              ) {
                  Button(isArchived ? "Desarquivar" : "Arquivar") {
                      onArchive?()
                      dismiss()
                  }
                  
                  Button("Cancelar", role: .cancel) { }
              } message: {
                  Text(isArchived ?
                      "Este capítulo voltará a aparecer na lista principal." :
                      "Este capítulo será movido para os arquivados e ficará oculto."
                  )
              }
              
              .confirmationDialog(
                  "Excluir Capítulo",
                  isPresented: $showingDeleteConfirmation,
                  titleVisibility: .visible
              ) {
                  Button("Excluir", role: .destructive) {
                      onDelete?()
                      dismiss()
                  }
                  
                  Button("Cancelar", role: .cancel) { }
              } message: {
                  Text("Esta ação não pode ser desfeita. Todos os pensamentos deste capítulo serão permanentemente excluídos.")
              }
         }
         .tint(Color(hex: chapterHex))
         .onAppear {
             let appearance = UINavigationBarAppearance()
             
             // Cor dos botões (incluindo o botão de voltar)
             appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: Color(hex: chapterHex)]
             
             // Cor da seta de voltar
             UINavigationBar.appearance().tintColor = UIColor(Color(hex: chapterHex))
         }
         .onDisappear {
             // Restaurar as cores padrão
             UINavigationBar.appearance().tintColor = nil
         }
     }
     
     // MARK: - Content Views
     @ViewBuilder
     private var thoughtListContent: some View {
         List {
             if !thoughts.isEmpty {
                 thoughtsSection
             } else {
                 noResultsSection
             }
         }
         .listStyle(.grouped)
         .listRowInsets(EdgeInsets())
         .scrollContentBackground(.hidden)


     }
     
    private var thoughtsSection: some View {
        ForEach(groupedThoughts, id: \.date) { group in
            Section {
                LazyVStack {
                    ForEach(group.thoughts) { thought in
                        Button {
                            selectedThought = thought
                        } label: {
                            ThoughtRowView(thought: thought, showBanner: showBanner)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
                
            } header: {
                Text(dayTitle(for: group.date))
                    .font(DesignTokens.Typography.tag)
                    .textCase(.lowercase)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(Visibility.hidden, edges: .all)
         

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
                 Text("Sem pensamentos ainda.")
                     .font(.title2)
                     .fontWeight(.medium)
                 
                 Text("Adicione um pensamento na tela de início")
                     .font(.callout)
                     .foregroundColor(.secondary)
                     .multilineTextAlignment(.center)
             }
         }
         .padding(.bottom, 40)
         .frame(maxWidth: .infinity, maxHeight: .infinity)
     }
     
     // MARK: - Toolbar
     @ToolbarContentBuilder
     private var toolbarContent: some ToolbarContent {
         //if journey != nil {
             ToolbarItem(placement: .navigationBarTrailing) {
                 journeyMenuButton
             }
         
         ToolbarItem(placement: .navigation) {
             Button {
                dismiss()
             } label: {
                 HStack(spacing: 4) {
                     Image(systemName: "chevron.left")
                         .fontWeight(.medium)
                     Text("Voltar")
                 }
             }
             .font(.body)
         }
        // }
         
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
                onEdit?()
            } label: {
                Label("Editar Capítulo", systemImage: "pencil")
            }
            
            Button {
                showingArchiveConfirmation = true
            } label: {
                Label(
                    isArchived ? "Desarquivar" : "Arquivar",
                    systemImage: "archivebox"
                )
            }
            
            Divider()
            
            Button(role: .destructive) {
                showingDeleteConfirmation = true
            } label: {
                Label("Excluir Capítulo", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
     
     // MARK: - Helper Methods
//     private func filteredThoughts(from thoughts: [Thought]) -> [Thought] {
//         let filtered = thoughts.filter { thought in
//             if searchText.isEmpty {
//                 return true
//             }
//             
//             return thought.content.localizedCaseInsensitiveContains(searchText) ||
//                    thought.notes?.localizedCaseInsensitiveContains(searchText) == true 
//             //thought.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
//         }
//         
//         // Ordenar por data de modificação (mais recente primeiro)
//         return filtered.sorted { $0.modifiedDate > $1.modifiedDate }
//     }
     
    // MARK: - Agrupar por dia
    private var groupedThoughts: [(date: Date, thoughts: [Thought])] {
        let grouped = Dictionary(grouping: thoughts) { thought in
            // Normalizar só pela data (sem hora)
            Calendar.current.startOfDay(for: thought.createdDate)
        }
        
        // Ordenar por data decrescente
        return grouped
            .map { (date: $0.key, thoughts: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    private func dayTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        
        if Calendar.current.isDateInToday(date) {
            return "Hoje"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Ontem"
        } else {
            formatter.dateFormat = "E, dd MMM"
            return formatter.string(from: date)
        }
    }

 
     
     // MARK: - Actions
//     private func deleteThought(_ thought: Thought) {
//         withAnimation {
//             context.delete(thought)
//             try? context.save()
//         }
//     }
//     
//     private func toggleFavorite(_ thought: Thought) {
//         withAnimation {
//             thought.isFavorite.toggle()
//             thought.updateModifiedDate()
//             try? context.save()
//         }
//     }
     
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
     
//     private func archiveJourney() {
//         guard let journey = journey else { return }
//         
//         withAnimation {
//             journey.isArchived.toggle()
//             try? context.save()
//         }
//     }
     
//     private func deleteJourney() {
//         guard let journey = journey else { return }
//         
//         withAnimation {
//             context.delete(journey)
//             try? context.save()
//             
//             
//         }
//         
//         
//     }
 }


struct TagFilterRowView: View {
    
    var body: some View {
        VStack {
             Text("d")
        }
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Filtros Ativos")
//                .font(.caption)
//                .foregroundColor(.secondary)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 8) {
//                    ForEach(Array(thoughtViewModel.selectedTags), id: \.self) { tag in
//                        HStack(spacing: 4) {
//                            Text("#\(tag)")
//                                .font(.caption)
//                            
//                            Button {
//                                thoughtViewModel.toggleTag(tag)
//                            } label: {
//                                Image(systemName: "xmark")
//                                    .font(.caption2)
//                            }
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 6)
//                        .background(Color.blue.opacity(0.2))
//                        .foregroundColor(.blue)
//                        .clipShape(Capsule())
//                    }
//                    
//                    Button {
//                        thoughtViewModel.clearTagFilters()
//                    } label: {
//                        Text("Limpar Tudo")
//                            .font(.caption)
//                            .foregroundColor(.red)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 6)
//                            .overlay(
//                                Capsule()
//                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
//                            )
//                    }
//                }
//                .padding(.horizontal, 1)
//            }
//        }
    }
}


#Preview {
    NavigationStack {
        ChapterDetailedView(
            chapterTitle: "Recentes",
            chapterDescription: "a",
            chapterIcon: "folder.fill",
            chapterHex: "999999",
            chapterStartDate: Date(),
            isArchived: false, 
            thoughts: Thought.defaultThoughts,
            showBanner: false
        )
    }
}

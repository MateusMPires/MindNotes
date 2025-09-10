// MARK: - Design System Components for Journey Gallery

import SwiftUI
import SwiftData



struct ThoughtsContentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var thoughts: [Thought] = []
    @State private var searchText: String = ""
    
    // Navigation...
    @State private var selectedThought: Thought? = nil
        
    @EnvironmentObject var journeyService: JourneyService
    @EnvironmentObject var thoughtService: ThoughtService

    // Filtro atual
     enum Filter: String {
         case todos, favoritos, ecos
     }
     
     @State private var selectedFilter: Filter = .todos
     
     // Computed property para retornar os pensamentos filtrados
     private var filteredThoughts: [Thought] {
         switch selectedFilter {
         case .todos:
             return thoughts
         case .favoritos:
             return thoughts.filter { $0.isFavorite }
         case .ecos:
             return thoughts.filter { $0.shouldRemind }
         }
     }
    
    // MARK: - Main View
      var body: some View {
          NavigationStack {
              ZStack {
                  AppBackground()
                  
                  VStack(spacing: 0) {
                      
                      VStack(spacing: 80) {
                          
                          ScrollView {
                              VStack(spacing: 64) {
                                  VStack(alignment: .center, spacing: 8) {
                                      Image(systemName: "list.bullet")
                                          .font(.system(size: 16))
                                          .foregroundStyle(.white)
                                          .padding(10)
                                          .background(Color.accentColor)
                                          .clipShape(Circle())
                                      
                                      Text("acervo.")
                                          .font(DesignTokens.Typography.title)
                                          .textCase(.lowercase)
                                          .foregroundStyle(DesignTokens.Colors.primaryText)
                                      
                                      // Filtros
                                      HStack(spacing: 32) {
                                          filterButton(title: "todos", filter: .todos)
                                          filterButton(title: "favoritos", filter: .favoritos)
                                          filterButton(title: "ecos", filter: .ecos)
                                      }
                                      .font(.custom("Outfit-Light", size: 12))
                                      .padding(.top, 12)
                                  }
                                  .listRowBackground(Color.clear)
                                  .listRowSeparator(Visibility.hidden, edges: .all)
                                  
                                  
                                  if !filteredThoughts.isEmpty {
                                      thoughtsSection
                                  } else {
                                      noResultsSection
                                  }
                              }
                          }
                          .listStyle(.grouped)
                          .listRowInsets(EdgeInsets())
                          .scrollContentBackground(.hidden)
                          
                      }
                  }
                  .navigationDestination(item: $selectedThought) { thought in
                      ThoughtDetailedView(thought: thought)
                  }
                  .padding(.top, 32)
                  .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                  .toolbarBackgroundVisibility(.hidden, for: .bottomBar)
                  .toolbar {
                      ToolbarItem(placement: .confirmationAction) {
                          Button {
                              dismiss()
                          } label: {
                              Image(systemName: "xmark.circle")
                                  .symbolRenderingMode(.hierarchical)
                          }
                      }
                  }
              }
          }
          .onAppear {
              do {
                  thoughts = try thoughtService.fetchAllThoughts()
              } catch {
                  // erro
              }
          }
      }
    // MARK: - Subviews
      @ViewBuilder
      private func filterButton(title: String, filter: Filter) -> some View {
          Button {
              selectedFilter = filter
          } label: {
              Text(title)
                  .foregroundColor(selectedFilter == filter ? .accentColor : .primary)
                  .fontWeight(selectedFilter == filter ? .bold : .regular)
          }
          .buttonStyle(.plain)
      }
    
   private var thoughtsSection: some View {
       ForEach(groupedThoughts, id: \.date) { group in
           Section {
               LazyVStack {
                   ForEach(group.thoughts) { thought in
                       Button {
                           selectedThought = thought
                       } label: {
                           ThoughtRowView(thought: thought, showBanner: false)
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
       .padding(.horizontal, 8)
   }
    
    private var noResultsSection: some View {
       // Section {
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
            .listRowBackground(Color.clear)
            .listRowSeparator(Visibility.hidden, edges: .all)
       // }
    }
}

extension ThoughtsContentView {
    private var groupedThoughts: [(date: Date, thoughts: [Thought])] {
        let grouped = Dictionary(grouping: filteredThoughts) { thought in
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

 
}
// MARK: - Preview
#Preview {
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    ThoughtsContentView()
        .modelContainer(sharedModelContainer)
        .environmentObject(JourneyService(context: sharedModelContainer.mainContext))
        .environmentObject(ThoughtService(context: sharedModelContainer.mainContext))

    
}

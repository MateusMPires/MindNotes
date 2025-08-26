// MARK: - Design System Components for Journey Gallery

import SwiftUI
import SwiftData



struct ChaptersGalleryView: View {
    
    // Navigation...
    @State private var selectedJourney: Journey?
    @State private var addNewJourney = false
    @State private var showingArchived = false
    @State private var openAllThoughts: Bool = false
    @Binding var showJourneyView: Bool
    
    
    // Data...
    @Query(sort: \Journey.createdDate, order: .reverse) private var journeys: [Journey]
    @EnvironmentObject var journeyService: JourneyService
    
    // Computed Properties
    private var activeJourneys: [Journey] {
        journeys.filter { !$0.isArchived }
    }
    
    private var archivedJourneys: [Journey] {
        journeys.filter { $0.isArchived }
    }
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // Chapters...
                        VStack(spacing: 60) {
                            
                            Text("Capítulos.")
                                .font(DesignTokens.Typography.title)
                                .textCase(.lowercase)
                                .foregroundStyle(DesignTokens.Colors.primary)
                            
                            VStack(spacing: 18) {
                                // General Chapters...
                                generalChaptersView
                                
                                // User's Chapters...
                                if !journeys.isEmpty {
                                    userChaptersView
                                }
                                
                                // Archived Chapters...
                                if showingArchived {
                                    userChaptersView
                                    // archivedJourneys
                                }
                            }
                            // Empty State...
                            if activeJourneys.isEmpty && !showingArchived {
                                EmptyJourneysView()
                                //.background(.green)
                            }
                        }
                        
                        // Tags...
                        Text("Etiquetas.")
                            .font(DesignTokens.Typography.title)
                            .foregroundStyle(DesignTokens.Colors.primary)
                            .textCase(.lowercase)
                            .padding(.top, 80)
                    }
                    .padding(.vertical, DesignTokens.Spacing.xl)
                    .padding(.horizontal, 24)
                }
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                .toolbarBackgroundVisibility(.hidden, for: .bottomBar)

                .toolbar {
                    // Leading toolbar item
                    if !archivedJourneys.isEmpty {
                        ToolbarItem(placement: .navigationBarLeading) {
                            IconButton(
                                iconName: showingArchived ? "eye.slash" : "eye",
                                size: 16,
                                action: toggleArchivedView
                            )
                        }
                    }
                    
                    // Trailing toolbar item
                    ToolbarItem(placement: .navigationBarTrailing) {
                        IconButton(
                            iconName: "xmark.circle.fill",
                            size: 20,
                            action: closeView
                        )
                    }
                    
                    // Bottom toolbar item
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button(action: { addNewJourney = true }) {
                                HStack(spacing: DesignTokens.Spacing.sm) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Adicionar capítulo")
                                }
                                .font(DesignTokens.Typography.subtitle)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: $addNewJourney) {
                    ChapterFormView(journey: selectedJourney)
                        .onDisappear { selectedJourney = nil }
                }
                .navigationDestination(item: $selectedJourney) { _ in 
                    ChapterDetailedView(allThoughts: false, journey: selectedJourney)
                }
                .navigationDestination(isPresented: $openAllThoughts) {
                    ChapterDetailedView(allThoughts: true, journey: nil)
                }
            }
        }
    }
    
    
    // MARK: - Actions
    
    private func navigateToJourney(_ journey: Journey) {
        selectedJourney = journey
    }
    
    private func editJourney(_ journey: Journey) {
        selectedJourney = journey
        addNewJourney = true
    }
    
    private func archiveJourney(_ journey: Journey) {
        withAnimation(DesignTokens.Animations.quick) {
            journeyService.archiveJourney(journey)
        }
    }
    
    private func unarchiveJourney(_ journey: Journey) {
        withAnimation(DesignTokens.Animations.quick) {
            journeyService.unarchiveJourney(journey)
        }
    }
    
    private func deleteJourney(_ journey: Journey) {
        withAnimation(DesignTokens.Animations.quick) {
            journeyService.deleteJourney(journey)
        }
    }
    
    private func toggleArchivedView() {
        withAnimation(DesignTokens.Animations.quick) {
            showingArchived.toggle()
        }
    }
    
    private func closeView() {
        showJourneyView.toggle()
    }
}

extension ChaptersGalleryView {
    var generalChaptersView: some View {
        HStack {
            VStack(alignment: .leading) {
                
                // Recents...
                JourneyRow(journey: Journey(name: "recentes"), onTap: {
                    openAllThoughts.toggle()
                })
                
                // Favorites...
                JourneyRow(journey: Journey(name: "favoritos"), onTap: {
                    openAllThoughts.toggle()
                })
                
                // Ecos...
                JourneyRow(journey: Journey(name: "ecos"), onTap: {
                    openAllThoughts.toggle()
                })

            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var userChaptersView: some View {
        HStack {
            VStack(alignment: .leading)  {
                Text("Criados por mim")
                    .font(DesignTokens.Typography.tag)
                    .foregroundStyle(.tertiary)
                    .textCase(.lowercase)
                    .padding(.vertical, 6)
                
                ForEach(journeys) { journey in
                    JourneyRow(journey: journey) {
                        selectedJourney = journey
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}


struct EmptyJourneysView: View {
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: "folder.badge.plus")
                .font(.largeTitle)
                .foregroundColor(DesignTokens.Colors.secondaryText)
            
            Text("Nenhum capítulo criado.")
                .font(DesignTokens.Typography.subtitle)
                .foregroundColor(DesignTokens.Colors.secondaryText)
            
            Text("Crie e organize seus pensamentos em capítulos da sua história.")
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
        .padding(.vertical, 50)
    }
}

struct JourneyRow: View {
    let journey: Journey
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignTokens.Spacing.md) {

                Image(systemName: "star.fill")
                    .font(DesignTokens.Typography.tag)
                    .foregroundStyle(.white)
                    .padding(6)
                    //.frame(width: 32, height: 32)
                    .background(.accent)
                    .clipShape(Circle())
                    .opacity(journey.isArchived ? 0.6 : 1.0)
                
                Text(journey.name)
                    .textCase(.lowercase)
                    .font(DesignTokens.Typography.body)
                    .tint(DesignTokens.Colors.primary)
                
                Text("(2)")
                    .font(DesignTokens.Typography.tag)
                    .tint(Color.secondary)
        
            }
            .padding(.vertical, 8)
        }
        
    }
}

// MARK: - Preview
#Preview {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    ChaptersGalleryView(showJourneyView: .constant(true))
        .modelContainer(for: Journey.self, inMemory: true)
        .environmentObject(JourneyService(context: sharedModelContainer.mainContext))
}

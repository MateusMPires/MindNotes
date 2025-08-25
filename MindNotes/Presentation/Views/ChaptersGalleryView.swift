// MARK: - Design System Components for Journey Gallery

import SwiftUI
import SwiftData


// MARK: - Special Sections

struct AllThoughtsRow: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: "tray.full.fill")
                    .foregroundColor(DesignTokens.Colors.primaryText)
                    .font(.title3)
                    .frame(width: 32, height: 32)
                    .background(DesignTokens.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.small))
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text("minha mente")
                        .font(DesignTokens.Typography.body)
                        .fontWeight(.medium)
                    Text("todos os pensamentos")
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.secondaryText)
                }
                
                Spacer()
            }
        }
    }
}

struct EmptyJourneysView: View {
    let onCreateJourney: () -> Void
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: "folder.badge.plus")
                .font(.largeTitle)
                .foregroundColor(DesignTokens.Colors.secondaryText)
            
            Text("Nenhuma jornada criada")
                .font(DesignTokens.Typography.subtitle)
                .foregroundColor(DesignTokens.Colors.secondaryText)
            
            Text("Crie sua primeira jornada para organizar seus pensamentos")
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button(action: onCreateJourney) {
                Text("Criar Jornada")
                    .fontWeight(.medium)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, minHeight: 400)
        .padding(.vertical, 100)
    }
}

// MARK: - Section Components

struct JourneySection: View {
    let title: String
    let journeys: [Journey]
    let onJourneyTap: (Journey) -> Void
    let onJourneyEdit: (Journey) -> Void
    let onJourneyArchive: (Journey) -> Void
    let onJourneyDelete: (Journey) -> Void
    let onJourneyUnarchive: ((Journey) -> Void)?
    
    var body: some View {
        if !journeys.isEmpty {
            Section(title) {
                ForEach(journeys) { journey in
                    JourneyRow(
                        journey: journey,
                        onTap: { onJourneyTap(journey) },
                        onEdit: { onJourneyEdit(journey) },
                        onArchive: { onJourneyArchive(journey) },
                        onDelete: { onJourneyDelete(journey) },
                        onUnarchive: onJourneyUnarchive.map { unarchive in { unarchive(journey) } }
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}


// MARK: - Main View Refatorada

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
                
                VStack(spacing: 0) {
                    List {
                        // Seção "Minha Mente"
                        Section {
                            AllThoughtsRow {
                                // Navigation to all thoughts
                                openAllThoughts.toggle()
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        
                        // Seção das Jornadas Ativas
                        JourneySection(
                            title: "Jornadas (\(activeJourneys.count))",
                            journeys: activeJourneys,
                            onJourneyTap: navigateToJourney,
                            onJourneyEdit: editJourney,
                            onJourneyArchive: archiveJourney,
                            onJourneyDelete: deleteJourney,
                            onJourneyUnarchive: nil
                        )
                        
                        // Seção das Jornadas Arquivadas
                        if showingArchived {
                            JourneySection(
                                title: "Arquivadas",
                                journeys: archivedJourneys,
                                onJourneyTap: navigateToJourney,
                                onJourneyEdit: editJourney,
                                onJourneyArchive: archiveJourney,
                                onJourneyDelete: deleteJourney,
                                onJourneyUnarchive: unarchiveJourney
                            )
                        }
                        
                        // Estado vazio
                        if activeJourneys.isEmpty && !showingArchived {
                            Section {
                                EmptyJourneysView {
                                    addNewJourney = true
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                .padding(.vertical, DesignTokens.Spacing.xl)
                }
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
                                    Text("Adicionar jornada")
                                }
                                .fontWeight(.semibold)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: $addNewJourney) {
                    NewJourneyFormView(journey: selectedJourney)
                        .onDisappear { selectedJourney = nil }
                }
                .navigationDestination(item: $selectedJourney) { _ in 
                    DetailedJourneyView(allThoughts: false, journey: selectedJourney)
                }
                .navigationDestination(isPresented: $openAllThoughts) {
                    DetailedJourneyView(allThoughts: true, journey: nil)
                }
            }
        }
    }
    
    // MARK: - Subviews
    

    
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

// MARK: - Journey Row Components

struct JourneyIcon: View {
    let emoji: String
    let isArchived: Bool
    
    var body: some View {
        Text(emoji)
            .font(DesignTokens.Typography.title)
            .frame(width: 32, height: 32)
            .background(DesignTokens.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.small))
            .opacity(isArchived ? 0.6 : 1.0)
    }
}

struct JourneyInfo: View {
    let journey: Journey
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text(journey.name)
                    .font(DesignTokens.Typography.body)
                    .fontWeight(.medium)
                
                if journey.isArchived {
                    StatusIndicator(
                        iconName: "archivebox.fill",
                        color: DesignTokens.Colors.notification,
                        size: .caption
                    )
                }
            }
            
            Text("\(journey.thoughtCount) pensamento\(journey.thoughtCount == 1 ? "" : "s")")
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.secondaryText)
        }
    }
}

struct JourneyActivity: View {
    let thoughtCount: Int
    
    var body: some View {
        if thoughtCount > 0 {
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
        }
    }
}

struct JourneyRow: View {
    let journey: Journey
    let onTap: () -> Void
    let onEdit: () -> Void
    let onArchive: () -> Void
    let onDelete: () -> Void
    let onUnarchive: (() -> Void)?
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignTokens.Spacing.md) {
                JourneyIcon(emoji: journey.emoji, isArchived: journey.isArchived)
                
                JourneyInfo(journey: journey)
                
                Spacer()
                
                JourneyActivity(thoughtCount: journey.thoughtCount)
            }
            .padding(.vertical, DesignTokens.Spacing.xs)
        }
        .contextMenu {
            journeyContextMenu
        }
        .swipeActions(edge: .trailing) {
            journeySwipeActions
        }
    }
    
    @ViewBuilder
    private var journeyContextMenu: some View {
        if !journey.isArchived {
            Button(action: onEdit) {
                Label("Editar", systemImage: "pencil")
            }
            
            Button(action: onArchive) {
                Label("Arquivar", systemImage: "archivebox")
            }
        } else if let onUnarchive = onUnarchive {
            Button(action: onUnarchive) {
                Label("Desarquivar", systemImage: "tray.and.arrow.up")
            }
        }
        
        Button(role: .destructive, action: onDelete) {
            Label("Excluir", systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private var journeySwipeActions: some View {
        Button(role: .destructive, action: onDelete) {
            Image(systemName: "trash.fill")
        }
        .tint(.red)
        
        if !journey.isArchived {
            Button(action: onArchive) {
                Image(systemName: "archivebox.fill")
            }
            .tint(.orange)
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

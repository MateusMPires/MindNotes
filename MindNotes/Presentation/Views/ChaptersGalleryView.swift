// MARK: - Design System Components for Journey Gallery

import SwiftUI
import SwiftData



struct ChaptersGalleryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // Navigation...
    @State private var showingArchived = false
    @State private var openJourneyForm: Bool = false
    @State private var chapterToEdit: Journey? = nil
    
    @Binding var showJourneyView: Bool
    
    
    // Data...
    @Query(sort: \Journey.createdDate, order: .reverse) private var journeys: [Journey]
    
    @EnvironmentObject var journeyService: JourneyService
    @EnvironmentObject var thoughtService: ThoughtService

    
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
                            
                            VStack(spacing: 12){
                                
//                                Image(systemName: "bookmark.fill")
//                                    .font(.system(size: 32))
//                                    .foregroundStyle(Color.accentColor)
                                
                                Text("Ciclos.")
                                    .font(DesignTokens.Typography.title)
                                    .textCase(.lowercase)
                                    .foregroundStyle(DesignTokens.Colors.primaryText)
                            }
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
                        }
                        
                        // Tags...
//                        Text("Etiquetas.")
//                            .font(DesignTokens.Typography.title)
//                            .foregroundStyle(DesignTokens.Colors.primary)
//                            .textCase(.lowercase)
//                            .padding(.top, 80)
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
                                size: 16) {
                                    
                                }
                            
                        }
                    }
                    
                    // Trailing toolbar item
                    ToolbarItem(placement: .navigationBarTrailing) {
                       
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .symbolRenderingMode(.hierarchical)

                        }
                    }
                    
                    // Bottom toolbar item
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button(action: { openJourneyForm.toggle() }) {
                                HStack(spacing: DesignTokens.Spacing.sm) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Adicionar capítulo")
                                }
                                .font(.custom("Outfit-Medium", size: 16))
                            }
                            
                            Spacer()
                        }
                    }
                }
                .fullScreenCover(item: $chapterToEdit) { _ in
                    ChapterFormView(journey: chapterToEdit, onJourneyEdited:  { journey in
                        
                        // Se tiver uma jornada selecionada, será edição
                        journeyService.editJourney(journey)
                    })
                }
                .fullScreenCover(isPresented: $openJourneyForm) {
                    ChapterFormView(journey: nil) { title, notes, icon, color in
                        
                        // Se tiver uma jornada selecionada, será edição
                        journeyService.saveJourney(
                            title: title!,
                            notes: notes,
                            icon: icon!,
                            color: color!
                        )
                    }
                }
                .navigationDestination(for: ChapterRoute.self) { route in
                    switch route {
                    case .journey(let journey):
                        ChapterDetailedView(
                            chapterTitle: journey.title,
                            chapterDescription: journey.notes ?? "",
                            chapterIcon: journey.icon,
                            chapterHex: journey.colorHex,
                            chapterStartDate: journey.createdDate,
                            isArchived: journey.isArchived,
                            thoughts: journey.thoughts ?? [],
                            showBanner: false
                            ,  onEdit:  {
                                chapterToEdit = journey
                            }, onArchive: {
                                journeyService.archiveJourney(journey)
                            }, onDelete: {
                                journeyService.deleteJourney(journey)
                            })
                        
                    case .filtered(let filter):
                        switch filter {
                        case .recents:
                            ChapterDetailedView(
                                chapterTitle: filter.title,
                                chapterDescription: filter.notes,
                                chapterIcon: filter.icon,
                                chapterHex: filter.colorHex,
                                chapterStartDate: Date(),
                                isArchived: filter.isArchived,
                                thoughts: try! thoughtService.fetchRecentThoughts(),
                                showBanner: true
                            )
                        case .favorites:
                            ChapterDetailedView(
                                chapterTitle: filter.title,
                                chapterDescription: filter.notes,
                                chapterIcon: filter.icon,
                                chapterHex: filter.colorHex,
                                chapterStartDate: Date(),
                                isArchived: filter.isArchived,
                                thoughts: try! thoughtService.fetchFavoriteThoughts(),
                                showBanner: true

                            )
                        case .echoes:
                            ChapterDetailedView(
                                chapterTitle: filter.title,
                                chapterDescription: filter.notes,
                                chapterIcon: filter.icon,
                                chapterHex: filter.colorHex,
                                chapterStartDate: Date(),
                                isArchived: filter.isArchived,
                                thoughts: try! thoughtService.fetchThoughtsWithReminders(),
                                showBanner: true

                            )
                        }
                    }
                }

            }
        }
    }
}

extension ChaptersGalleryView {
    var generalChaptersView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach([FilteredChapter.recents, .favorites, .echoes], id: \.self) { chapter in
                NavigationLink(value: ChapterRoute.filtered(chapter)) {
                    JourneyRowComponent(
                        title: chapter.title,
                        color: chapter.colorHex,
                        icon: chapter.icon,
                        thoughtsCount: 0 // ← pode calcular depois
                    )
                }
            }
        }
        .padding(.horizontal, 16)
    }

    
    var userChaptersView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Criados por mim")
                .font(DesignTokens.Typography.tag)
                .foregroundStyle(.tertiary)
                .textCase(.lowercase)
                .padding(.vertical, 6)
            
            ForEach(journeys) { journey in
                NavigationLink(value: ChapterRoute.journey(journey)) {
                    JourneyRowComponent(
                        title: journey.title,
                        color: journey.colorHex,
                        icon: journey.icon,
                        thoughtsCount: journey.thoughtCount
                    )
                }
            }
        }
        .padding(.horizontal, 16)
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
    
    ChaptersGalleryView(showJourneyView: .constant(true))
        .modelContainer(for: Journey.self, inMemory: true)
        .environmentObject(JourneyService(context: sharedModelContainer.mainContext))
}

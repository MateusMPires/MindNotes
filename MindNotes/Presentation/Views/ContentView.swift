import SwiftUI
import SwiftData


struct ContentView: View {
    
    // Navigation...
    @State private var addNewThought = false
    @State private var showJourneys = false
    @State private var showProfile = false
    
    @State private var selectedThought: Thought?

    @State private var beatAnimation: Bool = false
    @State private var position = ScrollPosition()
    
    @EnvironmentObject private var journeyService: JourneyService
    
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private var imageButton: String = "mainButton"
    
    // MARK: - MainView...
    var body: some View {
        NavigationStack {
            ZStack {
                // App Background...
                AppBackground()
                
                //ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    VStack(spacing: 160) {
                        headerView
                        
                        addThoughtButton

                    }
                    
                    recentsSection

                }
                
            }
            //.defaultScrollAnchor(.top)
//            .navigationDestination(item: $selectedThought) { thought in
//                ThoughtDetailedView(thought: thought)
//            }
            .sheet(isPresented: $addNewThought) {
                ThoughtFormView(journeys: journeyService.fetchJourneys())
            }
            .sheet(isPresented: $showJourneys) {
                ThoughtsContentView()
            }
            .onOpenURL { url in
                addNewThought = true
            }
            .onAppear {
                beatAnimation = true
            }
        }
    }
    
    // MARK: - Subviews as variables
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {

                VStack(spacing: 6) {
                    Text("ecos.")
                        .font(DesignTokens.Typography.title)
                        .foregroundStyle(DesignTokens.Colors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(formattedToday)
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(DesignTokens.Colors.secondaryText)
                }
                .padding(.horizontal)

            }

        }
        .padding(.vertical, 36)
        .padding(.top, 120)
    }
    
    private var addThoughtButton: some View {
        Button {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                addNewThought = true
            }
        } label: {
            PulseButtonView()
                .frame(width: 60, height: 60)
//                .overlay {
//                    Image(systemName: "keyboard.fill")
//                        .tint(.white)
//                }
        }
    }
    
    private var recentsSection: some View {
            VStack(alignment: .center, spacing: 0) {
                
                Spacer()
                
                Button {
                    showJourneys.toggle()

                } label: {
                    VStack(spacing: 8) {
                        
                        //Image(systemName: "chevron.up")
                        Text("acervo")
                            .font(DesignTokens.Typography.caption)
                            .foregroundStyle(DesignTokens.Colors.secondaryText)
                    }
//                        .foregroundStyle(.tertiary)
                }
                .tint(Color.secondary)
//
//                ForEach(thoughts.prefix(3), id: \.id) { thought in
//                    Button {
//                        selectedThought = thought
//                    } label: {
//                        ThoughtRowView(thought: thought, showBanner: true)
//                            .id(thought.id)
//                            .transition(.asymmetric(
//                                insertion: .move(edge: .trailing).combined(with: .opacity),
//                                removal: .move(edge: .leading).combined(with: .opacity)
//                            ))
//                            .animation(.spring(duration: 0.4), value: thought.id)
//                    }
//                }
//                
                // Chapters Button...
//                Button {
//                    showJourneys.toggle()
//                } label: {
//                    Image(systemName: "bookmark.fill")
//                        .foregroundStyle(.accent)
//                        .font(.system(size: 20))
//                        //.padding(10)
////                        .background {
////                            Circle()
////                                .stroke(.accent, style: StrokeStyle(lineWidth: 2))
////                        }
//                        
//                }
//                .padding(.vertical, 16)
            }
            .padding(.bottom, 40)
        
    }
}

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
    ContentView()
        .modelContainer(sharedModelContainer)
}

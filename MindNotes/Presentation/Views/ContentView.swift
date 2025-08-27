import SwiftUI
import SwiftData


struct ContentView: View {
    
    // Navigation...
    @State private var addNewThought = false
    @State private var showJourneys = false
    @State private var showProfile = false
    
    @State private var selectedThought: Thought?

    @State private var animateGradient: Bool = false
    @State private var isBubbling: Bool = false
    
    // Namespace para transição
    @Namespace private var transitionNamespace
    
    // SwiftData...
    @Query(sort: \Thought.createdDate, order: .reverse) private var thoughts: [Thought]
    
    
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
                
                ScrollView {
                   VStack(alignment: .center, spacing: 160) {
                        headerView
                       
                        addThoughtButton
                       
                       if !thoughts.isEmpty {
                           recentsSection
                       }
                    }
                }
            }
            .navigationDestination(item: $selectedThought) { thought in
                ThoughtDetailedView(thought: thought)
            }
            .navigationDestination(isPresented: $addNewThought) {
                ThoughtFormView(imageButton: imageButton, transitionNamespace: transitionNamespace)
                   // .navigationTransition(.zoom(sourceID: "d", in: transitionNamespace))
            }
            .sheet(isPresented: $showJourneys) {
                ChaptersGalleryView(showJourneyView: $showJourneys)
            }
            .onOpenURL { url in
                addNewThought = true
            }
        }
    }
    
    // MARK: - Subviews as variables
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                
                Button {
                    withAnimation(.easeInOut) { showJourneys = true }
                } label: {
                    Image(systemName: "tray.circle.fill")
                        .font(.system(size: 32))
                        .symbolRenderingMode(.hierarchical)
                }
                .hidden()
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text("echos.")
                        .font(DesignTokens.Typography.title)
                        .foregroundStyle(DesignTokens.Colors.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("11 agosto de 2025")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(DesignTokens.Colors.secondaryText)
                }
                .padding(.horizontal)
                
                Spacer()

                Button {
                    withAnimation(.easeInOut) { showJourneys = true }
                } label: {
                    Image(systemName: "brain.fill")
                        .font(.system(size: 20))
                        .symbolRenderingMode(.hierarchical)
                }
                .padding(.bottom)
                .hidden()
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
            ZStack {
                Image(imageButton)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .matchedTransitionSource(id: imageButton, in: transitionNamespace)

                // Ícone no centro
                Image(systemName: "leaf")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .hidden()
            }
           
        }
    }
    
    private var recentsSection: some View {
            VStack(alignment: .center, spacing: 24) {
                Text("Recentes")
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(DesignTokens.Colors.secondaryText)
                
                ForEach(thoughts.prefix(3), id: \.id) { thought in
                    Button {
                        selectedThought = thought
                    } label: {
                        ThoughtRowView(thought: thought)
                            .id(thought.id)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                            .animation(.spring(duration: 0.4), value: thought.id)
                    }
                }
                
                // Chapters Button...
                Button {
                    showJourneys.toggle()
                } label: {
                    Image(systemName: "bookmark.fill")
                        .foregroundStyle(.accent)
                        .padding(10)
                        .background {
                            Circle()
                                .stroke(.accent, style: StrokeStyle(lineWidth: 2))
                        }
                        
                }
                .padding(.vertical, 16)
            }
            .padding()
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Journey.self, Thought.self], inMemory: true)
}

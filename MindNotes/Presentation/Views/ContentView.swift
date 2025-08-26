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
                            .matchedTransitionSource(id: addNewThought, in: transitionNamespace)
                        
                        recentsSection
                    }
                }
            }
            .navigationDestination(item: $selectedThought) { thought in
                ThoughtDetailedView(thought: thought)
            }
            .navigationDestination(isPresented: $addNewThought) {
                ThoughtFormView(namespace: transitionNamespace)
                    .navigationTransition(.zoom(sourceID: addNewThought, in: transitionNamespace))
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
                    Text("uma frase bem legal.")
                        .font(DesignTokens.Typography.title)
                        .foregroundStyle(DesignTokens.Colors.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("11 ago")
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
        //.background(.green)
        //.padding(.horizontal, 24)
    }
    
    private var addThoughtButton: some View {
        Button {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                addNewThought = true
            }
        } label: {
            ZStack {
                Image("mainButton")
                    .resizable()
                    .frame(width: 60, height: 60)
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
            
            ForEach(0..<3) { thought in
                Button {
                    selectedThought = thoughts.first
                } label: {
                    ThoughtRowView(thought: thoughts[thought])
                        .id(thoughts.first?.id)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .animation(.spring(duration: 0.4), value: thoughts.first?.id)
                }
            }
            
            // Chapters Button...
            Button {
                // Go to Chapters...
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
        
    
    @ViewBuilder
    func LastThoughtView(_ thought: Thought) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .center, spacing: 24) {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(thought.content)
                            .font(DesignTokens.Typography.body)
                            .multilineTextAlignment(.leading)
                        
                        if let notes = thought.notes, !notes.isEmpty {
                            Image(systemName: "line.3.horizontal")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 4)
                    
                    Spacer()
                }
            }
            
            Divider()
            
            HStack {
                HStack(spacing: 6) {
                    if !thought.tags.isEmpty {
                        ForEach(thought.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(DesignTokens.Typography.tag)
                                .textCase(.lowercase)
                                .padding(.leading, 8)
                                .padding(.vertical, 3)
                                .foregroundColor(.primary)
                        }
                    }
                    Text(thought.journey?.name ?? "em minha mente")
                        .font(DesignTokens.Typography.tag)
                        .italic()
                    
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
                .padding(.horizontal, 1)
                .foregroundColor(.secondary)
            }
            
        }
        .padding()
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                .background(.white.opacity(0.05))
        }
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Journey.self, Thought.self], inMemory: true)
}

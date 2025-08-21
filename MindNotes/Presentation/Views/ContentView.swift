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
                   VStack(alignment: .center, spacing: 220) {
                        headerView
                       
                        addThoughtButton
                            .matchedTransitionSource(id: addNewThought, in: transitionNamespace)
                        
                        recentsSection
                    }
                   .background(.red)
                }
                .background(.yellow)
            }
            .navigationDestination(item: $selectedThought) { thought in
                DetailedThoughtView(thought: thought)
            }
            .navigationDestination(isPresented: $addNewThought) {
                NewThoughtFormView(namespace: transitionNamespace)
                    .navigationTransition(.zoom(sourceID: addNewThought, in: transitionNamespace))
            }
            .sheet(isPresented: $showJourneys) {
                GalleryJourneyView(showJourneyView: $showJourneys)
            }
            .onOpenURL { url in
                addNewThought = true
            }
        }
        .tint(.primary)
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
                
                VStack {
                    Text("mind notes")
                        .font(DesignTokens.Typography.title)
                    Text("de mateus")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
//                
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
            .padding(.vertical, 36)

        }
        .background(.green)
        //.padding(.horizontal, 24)
    }
    
    private var addThoughtButton: some View {
        Button {
//            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
//                addNewThought = true
//            }
            
            withAnimation(.smooth) {
                addNewThought = true
            }
                
            
        } label: {
            ZStack {
                // Fundo circular com gradiente animado
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.4), Color.blue],
                            startPoint: animateGradient ? .topLeading : .bottomTrailing,
                            endPoint: animateGradient ? .bottomTrailing : .topLeading
                        )
                    )
                    .frame(width: 70, height: 70)
//                    .scaleEffect(isBubbling ? 1.1 : 1.0) // efeito de bolha
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)

                // Ícone no centro
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .background(.mint)
        .onAppear {
            // Inicia a animação infinita do gradiente
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
            // Inicia a animação infinita da bolha
//            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
//                isBubbling.toggle()
//            }
        }
    }
    
    private var recentsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recente")
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)
            
            Button {
                selectedThought = thoughts.first
            } label: {
                LastThoughtView(thoughts.first ?? Thought(content: "Sem nenhum pensamento por enquanto..."))
                    .padding(.horizontal)
                    .id(thoughts.first?.id) // 🔹 Força o SwiftUI a tratar como nova view
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                                .padding()
                                .animation(.spring(duration: 0.4), value: thoughts.first?.id)
            }
        }
        .background(.blue)
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
        .modelContainer(for: Thought.self, inMemory: true)
}

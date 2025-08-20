import SwiftUI
import SwiftData


struct ContentView: View {
    
    // Navigation...
    @State private var addNewThought = false
    @State private var showJourneys = false
    @State private var showProfile = false
    
    @State private var selectedThought: Thought?

    // Namespace para transição
    @Namespace private var thoughtNamespace
    
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
                
                VStack(alignment: .center, spacing: 180) {
                    headerView
                    
                    addThoughtButton
                    
                    recentsSection
                }
            }
            .navigationDestination(item: $selectedThought) { thought in
                DetailedThoughtView(thought: thought)
            }
            .sheet(isPresented: $addNewThought) {
                NewThoughtFormView(namespace: thoughtNamespace)
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
                
                Button {
                    withAnimation(.easeInOut) { showJourneys = true }
                } label: {
                    Image(systemName: "brain.fill")
                        .font(.system(size: 20))
                        .symbolRenderingMode(.hierarchical)
                }
                .padding(.bottom)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    private var addThoughtButton: some View {
        VStack(spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.6)) {
                    addNewThought = true
                }
            } label: {
                Image(systemName: "lightbulb.circle.fill")
                    //.resizable()
                    //.aspectRatio(contentMode: .fit)
                    //.clipShape(Circle())
                    .font(.system(size: 40))
                    .foregroundStyle(.primary)
                    .padding(20)
                    .bold()
            }
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

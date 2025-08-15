import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var thoughtViewModel = ThoughtViewModel()
    
    @State private var addNewThought = false
    @State private var showJourneys = false
    @State private var showProfile = false

    // SwiftData...
    @Environment(\.modelContext) private var context
    @Query(sort: \Thought.createdDate, order: .reverse) private var thoughts: [Thought]
    
    // MARK: - Computed property para data formatada
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    // MainView...
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 180) {
                headerView
                
                addThoughtButton
                
                
               // Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Recente")
                        .font(.custom("Manrope-Regular", size: 12))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)
                    
                    LastThoughtView(thoughts.first ?? Thought(content: "Sem nenhum pensamento por enquanto..."))
                        .padding()
                }
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Último registro")
//                        .font(.callout)
//                        .foregroundStyle(.secondary)
//                    
//                    Text("Alguma frase muito massa")
//                }
//                    .padding()
//                    .padding(.horizontal)
//                    .background {
//                        TransparentBlurView(removeAllFilters: true)
//                            .blur(radius: 9, opaque: true)
//                            // Adjust this opacity to a more glossy feel
//                            .background(.white.opacity(0.05))
//                    }
//                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
//                    .background {
//                        RoundedRectangle(cornerRadius: 12, style: .continuous)
//                            .stroke(.white.opacity(0.3), lineWidth: 1)
//                    }
                
//                Spacer()
//                VStack {
//                    Text("Aqui vai ser tipo os meus pensamentos")
//                        
//                }
//                .padding(.vertical, 60)
//                .hidden()
//                
//                Text("Hoje")
//                    .font(.title3)
//                    .padding(.horizontal)
//                
//                if thoughts.isEmpty {
//                    emptyThoughtsView
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else {
//                    thoughtsListView
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        //Color.gray.opacity(0.2),
//                        //                Color(hex: "#2F4858"),
//                        //Color.white.opacity(0.1),
//                        
//                        // Color(hex: "#818B8B")
//                        //                Color(hex: "#696969"),
//                        Color(hex: "#131313")
//                        //                Color(hex: "#1A1D29")
//                        
//                        //Color(hex: "#09203F"),
//                       // Color(hex: "#1EAE98")
//                    ]),
//                    startPoint: .bottomTrailing,
//                    endPoint: .topTrailing
//                )
//                .ignoresSafeArea()
                
                Color(hex: "#131313")
                    .ignoresSafeArea()// cinza bem escuro nas bordas

//                RadialGradient(
//                        gradient: Gradient(colors: [
//                            Color(red: 0.36, green: 0.75, blue: 0.49), // #5CBE7D (verde)
//                            Color(red: 0.30, green: 0.63, blue: 0.41), // tom mais escuro do verde
//                            Color(hex: "#131313") // cinza bem escuro nas bordas
//                        ]),
//                        center: .center,
//                        startRadius: 50,
//                        endRadius: 70
//                    )
//                .ignoresSafeArea()
                //.blur(radius: 32)
                
                //#00C489
                //                Color.secondary
                //                    .opacity(0.25)
//                Circle()
//                    .foregroundStyle( RadialGradient(
//                        gradient: Gradient(colors: [
//                            Color(red: 0.36, green: 0.75, blue: 0.49), // #5CBE7D
//                            Color(red: 0.30, green: 0.63, blue: 0.41), // tom mais escuro
//                            Color(red: 0.44, green: 0.82, blue: 0.57)  // tom mais claro
//                        ]),
//                        center: .center,
//                        startRadius: 50,
//                        endRadius: 500
//                    ))
//                    .blur(radius: 80)
//                    .opacity(0.7)
                
            }
            .onAppear {
                context.insert(Thought(content: "Eu fiz isso e aquilo e aquilo e aquilo e aquilo", notes: "Eu fiz isso e isso e isso aqui e isso e isso e isso", tags: ["Conclusão"], shouldRemind: false))
            }
            .sheet(isPresented: $showJourneys) {
                GalleryJourneyView(showJourneyView: $showJourneys)
            }
            .sheet(isPresented: $addNewThought) {
                NewThoughtView()
            }
//            .safeAreaInset(edge: .bottom) {
//                addThoughtButton
//            }
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
                        .font(.custom("Outfit-Regular", size: 24))
                    //.bold()
                    Text("de mateus")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                
//                Button {
//                    
//                } label: {
//                    Image(systemName: "magnifyingglass.circle.fill")
//                        .font(.system(size: 32))
//                        .symbolRenderingMode(.hierarchical)
//
//                }
                
                Button {
                    withAnimation(.easeInOut) { showJourneys = true }
                } label: {
                    Image(systemName: "brain.fill")
                        .font(.system(size: 20))
                        .symbolRenderingMode(.hierarchical)
                }
                //.padding(.horizontal, 16)
                .padding(.bottom)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    private var emptyThoughtsView: some View {
        ContentUnavailableView(
            "Sem pensamentos",
            systemImage: "bubble.left.and.bubble.right",
            description: Text("Adicione um novo pensamento para começar sua jornada.")
        )
    }
    
    private var thoughtsListView: some View {
        List {
            ForEach(thoughts) { thought in
//                NavigationLink {
//                    DetailedThoughtView(thought: thought)
//                        .environmentObject(thoughtViewModel)
//                } label: {
                    ThoughtRowView(thought: thought)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

               // }
                    .swipeActions(edge: .leading) {
                        Button {
                            deleteThought(thought)
                            
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundStyle(.red)
                        }
                        .tint(.clear)
                    }
                .swipeActions(edge: .trailing) {
                    // Botão excluir
                    Button {
                        deleteThought(thought)
                        
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(.red)
                    }
                    .tint(.clear)


                    Button {
                        //thoughtViewModel.toggleFavorite(thought)
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .tint(.clear)
                    .clipShape(Circle())
                }
            }
        }
        .padding(.top)
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)


    }
    
    private var addThoughtButton: some View {
        VStack(spacing: 8) {
            
//            Text("O que você está pensando agora?")
//                .multilineTextAlignment(.center)
//                .font(.custom("Outfit-Regular", size: 36))
//                //.font(.system(size: 36))

            Button {
                addNewThought = true
            } label: {
                Image(systemName: "lightbulb.circle.fill")
                    .font(.system(size: 40))
//                    .foregroundStyle( Color(hex: "#5CBE7D"))
                    .foregroundStyle(.primary)
                    .padding(20)
                    .bold()
//                    .background(
//                        Color(hex: "#5CBE7D")
//                        //.secondary
//                    )
                //                .background(Color(hex: "#00C489"))
                    //.clipShape(Circle())
            }
            //.frame(maxWidth: .infinity)
        }
        
        
    }
    
    private func deleteThought(_ thought: Thought) {
        context.delete(thought)
    }
    
    @ViewBuilder
    func LastThoughtView(_ thought: Thought) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .center, spacing: 24) {
               
                    //.padding(.horizontal)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(thought.content)
                            .font(.custom("Manrope-Regular", size: 16))
                        
                        if let notes = thought.notes, !notes.isEmpty {
                            Image(systemName: "line.3.horizontal")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    Spacer()
                }
            }
            Divider()
            
            HStack {
                if !thought.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(thought.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.custom("Manrope-Regular", size: 10))
                                .textCase(.lowercase)
                                .padding(.leading, 8)
                                .padding(.vertical, 3)
                                .foregroundColor(.primary)
                        }
                        
                        Text(thought.journey == nil ? "em minha mente" : (thought.journey?.name ?? ""))
                            .font(.custom("Manrope-Regular", size: 10))
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

struct ThoughtRowView: View {
    let thought: Thought
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                
//                Circle()
//                    .frame(width: 16, height: 24)
//                    .foregroundColor(.primary.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(thought.content)
                          //.font(.custom("InstrumentSans-Regular", size: 16))
                          .font(.custom("Manrope-Regular", size: 16))

                        //.fontWeight(.medium)
                        //.lineLimit(3)
                    
                    if let notes = thought.notes, !notes.isEmpty {
                        Image(systemName: "line.3.horizontal")
                        //Text(notes)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            //.lineLimit(2)
                    }
                }
                .padding(.horizontal, 4)
                
                Spacer()
                
            }
            
            Divider()
            
            HStack {
                
//                Text(formatDate(thought.createdDate))
//                    .font(.caption2)
//                    .foregroundColor(.secondary)
//                
//                Spacer()
//
                if !thought.tags.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(thought.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.custom("Manrope-Regular", size: 10))
                                    //.font(.caption2)
                                    .textCase(.lowercase)
                                    .padding(.leading, 8)
                                    .padding(.vertical, 3)
                                    //.background(Color.blue.opacity(0.1))
                                    .foregroundColor(.primary)
                                    //.clipShape(Capsule())
                            }
                            
                            Text("em luto")
                                .font(.custom("Manrope-Regular", size: 10))
                                //.bold()
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
        }
        .padding()
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                // Adjust this opacity to a more glossy feel
                .background(.white.opacity(0.05))
        }
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE, d 'de' MMM"
        return formatter.string(from: date)
            .capitalized  // Para garantir que a primeira letra seja maiúscula
    }

}

#Preview {
    ThoughtRowView(thought: .init(content: "kdshjf"))
}

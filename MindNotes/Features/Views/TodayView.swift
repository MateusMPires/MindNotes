//
//  TodayView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var thoughtViewModel = ThoughtViewModel()
    @State private var showingNewThought = false
    @State private var showJourneys = false
    @State private var showProfile = false

    // MARK: - Computed property para data formatada
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(title: "mind notes", subtitle: formattedToday)

                if thoughtViewModel.todayThoughts.isEmpty {
                    EmptyThoughtsView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                } else {
                    ThoughtsListView(thoughts: thoughtViewModel.todayThoughts, viewModel: thoughtViewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.easeInOut) { showJourneys = true }
                    } label: {
                        Image(systemName: "tray.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
            .sheet(isPresented: $showJourneys) {
                JourneyListView(isShowing: $showJourneys)
            }
            .fullScreenCover(isPresented: $showProfile) {
                NavigationStack {
                    ProfileView()
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Fechar") { showProfile = false }
                                    .bold()
                            }
                        }
                }
            }
            .sheet(isPresented: $showingNewThought) {
                NewThoughtView()
                    .environmentObject(thoughtViewModel)
            }
            .onAppear {
                thoughtViewModel.loadThoughts()
            }
        }
        .safeAreaInset(edge: .bottom) {
            AddThoughtButton {
                showingNewThought = true
            }
        }
        .tint(.primary)
    }
}

// MARK: - Subviews

struct HeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.largeTitle)
                .bold()
//            Text(subtitle)
//                .font(.callout)
//                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct EmptyThoughtsView: View {
    var body: some View {
        ContentUnavailableView(
            "Sem pensamentos",
            systemImage: "bubble.left.and.bubble.right",
            description: Text("Adicione um novo pensamento para começar sua jornada.")
        )
    }
}

struct ThoughtsListView: View {
    let thoughts: [Thought]
    let viewModel: ThoughtViewModel

    var body: some View {
        List {
            ForEach(thoughts) { thought in
                NavigationLink {
                    DetailedThoughtView(thought: thought)
                        .environmentObject(viewModel)
                } label: {
                    ThoughtRowView(thought: thought)
                        .environmentObject(viewModel)
                }
                .swipeActions(edge: .trailing) {
                    // Botão excluir
                    Button {
                        viewModel.deleteThought(thought)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .tint(.clear) // remove o retângulo de fundo padrão


                    
                    
                    Button {
                        viewModel.toggleFavorite(thought)
                    } label: {
                        Label(
                            thought.isFavorite ? "Desfavoritar" : "Favoritar",
                            systemImage: thought.isFavorite ? "star.slash" : "star"
                        )
                    }.tint(.gray)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct AddThoughtButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 60))
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodayView()
}

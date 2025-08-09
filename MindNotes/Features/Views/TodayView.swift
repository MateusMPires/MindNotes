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
    @State private var isActivatingComposer = false
    @State private var showJourneys = false
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            Group {
                if thoughtViewModel.todayThoughts.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        composerField
                            .padding(.horizontal)
                        Spacer()
                        Text("Nenhum pensamento por enquanto")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    VStack(spacing: 12) {
                        composerField
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        List {
                            ForEach(thoughtViewModel.todayThoughts) { thought in
                                NavigationLink {
                                    DetailedThoughtView(thought: thought)
                                        .environmentObject(thoughtViewModel)
                                } label: {
                                    ThoughtRowView(thought: thought)
                                        .environmentObject(thoughtViewModel)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) { thoughtViewModel.deleteThought(thought) } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                    Button { thoughtViewModel.toggleFavorite(thought) } label: {
                                        Label(thought.isFavorite ? "Desfavoritar" : "Favoritar", systemImage: thought.isFavorite ? "star.slash" : "star")
                                    }.tint(.gray)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle("journey")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.easeInOut) { showJourneys = true }
                    } label: {
                        Image(systemName: "folder")
                    }
                    .foregroundStyle(.primary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.easeInOut) { showProfile = true }
                    } label: {
                        Image(systemName: "person")
                    }
                    .foregroundStyle(.primary)
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            showingNewThought = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                Text("Novo pensamento")
                            }
                            .font(.callout.weight(.semibold))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.primary)
                        Spacer()
                    }
                }
            }
            .fullScreenCover(isPresented: $showJourneys) {
                NavigationStack {
                    JourneyListView()
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Fechar") { showJourneys = false }
                                    .bold()
                            }
                        }
                }
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
            .onAppear { thoughtViewModel.loadThoughts() }
        }
        .tint(.primary)
    }
    
    // MARK: - Composer
    private var composerField: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                isActivatingComposer = true
            }
            // Pequeno atraso para sentir a animação de foco
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                showingNewThought = true
                isActivatingComposer = false
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("Novo pensamento...")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.secondary.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
            )
            .scaleEffect(isActivatingComposer ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Adicionar novo pensamento")
    }
}

#Preview {
    TodayView()
}


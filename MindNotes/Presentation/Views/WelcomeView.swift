//
//  WelcomeView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Bem-vindo ao MindNotes",
            subtitle: "Sua jornada de autoconhecimento começa aqui",
            description: "Organize seus pensamentos, reflexões e insights em jornadas significativas.",
            systemImage: "brain.head.profile",
            color: .blue
        ),
        OnboardingPage(
            title: "Organize por Jornadas",
            subtitle: "Categorize seus pensamentos",
            description: "Crie jornadas para diferentes áreas da sua vida: trabalho, relacionamentos, objetivos pessoais.",
            systemImage: "folder.fill",
            color: .green
        ),
        OnboardingPage(
            title: "Etiquete e Encontre",
            subtitle: "Use tags para organizar",
            description: "Adicione etiquetas aos seus pensamentos para encontrá-los facilmente quando precisar.",
            systemImage: "tag.fill",
            color: .orange
        ),
        OnboardingPage(
            title: "Lembre-se no Futuro",
            subtitle: "Notificações inteligentes",
            description: "Configure lembretes para revisitar pensamentos importantes em momentos específicos.",
            systemImage: "bell.fill",
            color: .purple
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom page indicator and buttons
            VStack(spacing: 32) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button("Anterior") {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(.secondary)
                    } else {
                        Button("Pular") {
                            dismiss()
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(currentPage == pages.count - 1 ? "Começar" : "Próximo") {
                        if currentPage == pages.count - 1 {
                            dismiss()
                        } else {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(pages[currentPage].color)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .background(Color(.systemBackground))
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundColor(page.color)
                .padding(.bottom, 16)
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineLimit(nil)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
    let color: Color
}

#Preview {
    WelcomeView()
}
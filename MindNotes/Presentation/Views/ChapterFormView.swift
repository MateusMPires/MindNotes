//
//  CreateJourneyView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

// Preciso de: Função de Criar uma jornada..

struct ChapterFormView: View {
    
    let journey: Journey?
    
    // Closure onSave()
    // Closure que retorna todas as informações de uma Journey
    var onJourneyCreated: ((_ title: String?,
                            _ notes: String?,
                            _ icon: String?,
                            _ color: Color?
                           ) -> Void)?

    var onJourneyEdited: ((_ journey: Journey) -> Void)?


    @EnvironmentObject private var journeyService: JourneyService
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var selectedIcon: String = "folder.fill"
    @State private var selectedColor: Color = .blue
    
    private let availableEmojis = ["📝", "🤔", "🎯", "🙏", "📚", "💡", "🌟", "❤️", "🎨", "🌱", "🚀", "✨", "💭", "🧠", "📖", "🎪", "🌈", "🦋", "🌸", "🍀"]
    
    private let availableColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink,
        .yellow, .indigo, .mint, .teal, .cyan, .brown
    ]
    
    private var isEditing: Bool {
        journey != nil
    }
    

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Preview
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Image(systemName: selectedIcon)
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .background(selectedColor)
                                .clipShape(Circle())
                                .foregroundStyle(.white)
                            
                            Text(title.isEmpty ? "Nome do Capítulo" : title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(title.isEmpty ? .secondary : .primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Section("Informações") {
                    TextField("Nome da Capítulo", text: $title)
                        .textInputAutocapitalization(.words)
                }
                
//                Section("Emoji") {
//                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
//                        ForEach(availableEmojis, id: \.self) { emoji in
//                            Button {
//                                selectedEmoji = emoji
//                            } label: {
//                                Text(emoji)
//                                    .font(.title2)
//                                    .frame(width: 44, height: 44)
//                                    .background(
//                                        selectedEmoji == emoji ? 
//                                        selectedColor.opacity(0.3) : 
//                                        Color.clear
//                                    )
//                                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .stroke(
//                                                selectedEmoji == emoji ? selectedColor : Color.clear,
//                                                lineWidth: 2
//                                            )
//                                    )
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                    .padding(.vertical, 8)
//                }
                
                Section("Cor") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(availableColors, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                Circle()
                                    .fill(color)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                    )
                                    .scaleEffect(selectedColor == color ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedColor)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle(isEditing ? "Editar Capítulo" : "Nova Capítulo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Salvar" : "Criar") {
                    
                        if isEditing {
                            onJourneyEdited?(journey!)
                        } else {
                            onJourneyCreated?(title, notes, selectedIcon, selectedColor)
                        }
                      
                        
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                       if let journey = journey {
                           title = journey.title
                           selectedIcon = journey.icon
                           selectedColor = Color(hex: journey.colorHex)
                       }
                   }
        }
    }

}



#Preview {
    ChapterFormView(journey: Journey(title: "Terapia"))
}

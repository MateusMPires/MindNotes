//
//  CreateJourneyView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

struct CreateJourneyView: View {
    @ObservedObject var journeyViewModel: JourneyViewModel
    let journey: Journey?
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var selectedEmoji: String = "📝"
    @State private var selectedColor: Color = .blue
    
    private let availableEmojis = ["📝", "🤔", "🎯", "🙏", "📚", "💡", "🌟", "❤️", "🎨", "🌱", "🚀", "✨", "💭", "🧠", "📖", "🎪", "🌈", "🦋", "🌸", "🍀"]
    
    private let availableColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink,
        .yellow, .indigo, .mint, .teal, .cyan, .brown
    ]
    
    private var isEditing: Bool {
        journey != nil
    }
    
    init(journeyViewModel: JourneyViewModel, journey: Journey? = nil) {
        self.journeyViewModel = journeyViewModel
        self.journey = journey
        
        if let journey = journey {
            _name = State(initialValue: journey.name)
            _selectedEmoji = State(initialValue: journey.emoji)
            _selectedColor = State(initialValue: Color(hex: journey.colorHex))
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Preview
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Text(selectedEmoji)
                                .font(.system(size: 60))
                                .frame(width: 100, height: 100)
                                .background(selectedColor.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text(name.isEmpty ? "Nome da Jornada" : name)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(name.isEmpty ? .secondary : .primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Section("Informações") {
                    TextField("Nome da jornada", text: $name)
                        .textInputAutocapitalization(.words)
                }
                
                Section("Emoji") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Button {
                                selectedEmoji = emoji
                            } label: {
                                Text(emoji)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        selectedEmoji == emoji ? 
                                        selectedColor.opacity(0.3) : 
                                        Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                selectedEmoji == emoji ? selectedColor : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
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
            .navigationTitle(isEditing ? "Editar Jornada" : "Nova Jornada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Salvar" : "Criar") {
                        saveJourney()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveJourney() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let journey = journey {
            // Edit existing journey
            journey.name = trimmedName
            journey.emoji = selectedEmoji
            journey.colorHex = selectedColor.toHex()
            journeyViewModel.updateJourney(journey)
        } else {
            // Create new journey
            journeyViewModel.createJourney(
                name: trimmedName,
                emoji: selectedEmoji,
                colorHex: selectedColor.toHex()
            )
        }
    }
}

// MARK: - Color Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

#Preview {
    CreateJourneyView(journeyViewModel: JourneyViewModel())
}
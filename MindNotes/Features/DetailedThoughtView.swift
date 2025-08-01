//
//  DetailedThought.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 28/07/25.
//

import SwiftUI
// View de destino para navegação
struct DetailedThoughtView: View {
    let thought: String
    let dateTime: String
    let tag: String
    let additionalNotes: String
    @State private var isFavorited: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Card principal do pensamento
                VStack(alignment: .leading, spacing: 16) {
                    // Header com tag e favorito
                    HStack {
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isFavorited.toggle()
                            }
                        }) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .foregroundColor(isFavorited ? .red : .gray)
                                .font(.title2)
                        }
                    }
                    
                    // Pensamento principal
                    Text(thought)
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    
                    // Data e hora
                    Text(dateTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding(20)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Notas adicionais
                if !additionalNotes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(.orange)
                                .font(.title3)
                            Text("Notas adicionais")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Text(additionalNotes)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Pensamento")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: {
                        // Compartilhar
                    }) {
                        Label("Compartilhar", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(action: {
                        // Editar
                    }) {
                        Label("Editar", systemImage: "pencil")
                    }
                    
                    Button(action: {
                        // Excluir
                    }) {
                        Label("Excluir", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
#Preview {
    NewThought(isShowing: .constant(true))
}

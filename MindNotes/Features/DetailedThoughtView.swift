//
//  DetailedThoughtView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

struct DetailedThoughtView: View {
    let thought: Thought
//    
//    @EnvironmentObject private var thoughtViewModel: ThoughtViewModel
//    @Environment(\.dismiss) private var dismiss
//    @State private var showingEditSheet = false
//    @State private var showingDeleteAlert = false
//    
    var body: some View {
        ScrollView {
//            VStack(alignment: .leading, spacing: 24) {
//                // Main thought card
//                VStack(alignment: .leading, spacing: 16) {
//                    // Header with journey and favorite
//                    HStack {
////                        if let journey = thought.journey {
////                            HStack(spacing: 8) {
////                                Text(journey.emoji)
////                                    .font(.body)
////                                    .frame(width: 28, height: 28)
////                                    .background(Color(hex: journey.colorHex).opacity(0.2))
////                                    .clipShape(RoundedRectangle(cornerRadius: 6))
////                                
////                                Text(journey.name)
////                                    .font(.caption)
////                                    .fontWeight(.medium)
////                                    .foregroundColor(Color(hex: journey.colorHex))
////                            }
////                        }
//                        
//                        Spacer()
//                        
//                        HStack(spacing: 12) {
//                            if thought.shouldRemind {
//                                Image(systemName: "bell.fill")
//                                    .foregroundColor(.orange)
//                                    .font(.caption)
//                            }
//                            
//                            Button {
//                                thoughtViewModel.toggleFavorite(thought)
//                            } label: {
//                                Image(systemName: thought.isFavorite ? "star.fill" : "star")
//                                    .foregroundColor(thought.isFavorite ? .yellow : .secondary)
//                                    .font(.title3)
//                            }
//                        }
//                    }
//                    
//                    // Main content
//                    Text(thought.content)
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.leading)
//                    
//                    // Date and time
//                    HStack {
//                        Text("Criado em \(formatDate(thought.createdDate))")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        if thought.modifiedDate != thought.createdDate {
//                            Text("• Editado em \(formatDate(thought.modifiedDate))")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//                .padding(20)
//                .background(Color(.systemBackground))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color(.systemGray5), lineWidth: 1)
//                )
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//                
//                // Tags section
//                if !thought.tags.isEmpty {
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack {
//                            Image(systemName: "tag.fill")
//                                .foregroundColor(.blue)
//                                .font(.callout)
//                            Text("Etiquetas")
//                                .font(.headline)
//                                .fontWeight(.medium)
//                        }
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 8) {
//                                ForEach(thought.tags, id: \.self) { tag in
//                                    Text("#\(tag)")
//                                        .font(.caption)
//                                        .padding(.horizontal, 12)
//                                        .padding(.vertical, 6)
//                                        .background(Color.blue.opacity(0.1))
//                                        .foregroundColor(.blue)
//                                        .clipShape(Capsule())
//                                }
//                            }
//                            .padding(.horizontal, 1)
//                        }
//                    }
//                    .padding(20)
//                    .background(Color(.systemGray6))
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                }
//                
//                // Additional notes
//                if let notes = thought.notes, !notes.isEmpty {
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack {
//                            Image(systemName: "note.text")
//                                .foregroundColor(.orange)
//                                .font(.callout)
//                            Text("Notas adicionais")
//                                .font(.headline)
//                                .fontWeight(.medium)
//                        }
//                        
//                        Text(notes)
//                            .font(.body)
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.leading)
//                    }
//                    .padding(20)
//                    .background(Color(.systemGray6))
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                }
//                
//                // Reminder section
//                if thought.shouldRemind, let reminderDate = thought.reminderDate {
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack {
//                            Image(systemName: "bell.fill")
//                                .foregroundColor(.orange)
//                                .font(.callout)
//                            Text("Lembrete")
//                                .font(.headline)
//                                .fontWeight(.medium)
//                        }
//                        
//                        Text("Relembrar em \(formatDate(reminderDate))")
//                            .font(.body)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(20)
//                    .background(Color.orange.opacity(0.1))
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                }
//                
//                Spacer(minLength: 50)
//            }
//            .padding()
        }
//        .navigationTitle("Pensamento")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Menu {
//                    Button {
//                        shareThought()
//                    } label: {
//                        Label("Compartilhar", systemImage: "square.and.arrow.up")
//                    }
//                    
//                    Button {
//                        showingEditSheet = true
//                    } label: {
//                        Label("Editar", systemImage: "pencil")
//                    }
//                    
//                    Divider()
//                    
//                    Button(role: .destructive) {
//                        showingDeleteAlert = true
//                    } label: {
//                        Label("Excluir", systemImage: "trash")
//                    }
//                } label: {
//                    Image(systemName: "ellipsis.circle")
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .sheet(isPresented: $showingEditSheet) {
//            NewThoughtView(thoughtToEdit: thought)
//                .environmentObject(thoughtViewModel)
//        }
//        .alert("Excluir Pensamento", isPresented: $showingDeleteAlert) {
//            Button("Cancelar", role: .cancel) { }
//            Button("Excluir", role: .destructive) {
//                thoughtViewModel.deleteThought(thought)
//                dismiss()
//            }
//        } message: {
//            Text("Esta ação não pode ser desfeita.")
//        }
    }
//    
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.locale = Locale(identifier: "pt_BR")
//        return formatter.string(from: date)
//    }
//    
//    private func shareThought() {
//        var shareText = thought.content
//        
//        if let notes = thought.notes, !notes.isEmpty {
//            shareText += "\n\n" + notes
//        }
//        
//        if !thought.tags.isEmpty {
//            shareText += "\n\nTags: " + thought.tags.map { "#\($0)" }.joined(separator: " ")
//        }
//        
//        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            window.rootViewController?.present(activityViewController, animated: true)
//        }
//    }
}

#Preview {
    let sampleThought = Thought(content: "Este é um pensamento de exemplo", notes: "Algumas notas adicionais", tags: ["exemplo", "teste"])
    
    NavigationStack {
        DetailedThoughtView(thought: sampleThought)
//            .environmentObject(ThoughtViewModel())
    }
}



import SwiftUI

struct ThoughtDetailedView: View {
    
    @Environment(\.modelContext) private var context
    
    let thought: Thought
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            
            AppBackground()
            
            ScrollView {
                VStack(alignment: .center, spacing: 32) {
                    thoughtCard
  
                    Spacer()
                    
                    actionButtons
                }
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showingEditSheet) {
                ThoughtEditFormView(journeys: [], thoughtToEdit: thought, draft: ThoughtDraft(content: thought.content, notes: thought.notes ?? "", createdDate: thought.createdDate, modifiedDate: thought.createdDate, isFavorite: thought.isFavorite, chapter: thought.chapter))
            }
            .alert("Excluir Pensamento", isPresented: $showingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Excluir", role: .destructive) {
                    // Delete thought logic here
                    context.delete(thought)
                    dismiss()
                }
            } message: {
                Text("Esta ação não pode ser desfeita.")
            }
        }
    }
    
    // MARK: - Main Thought Card
    private var thoughtCard: some View {
        VStack(alignment: .leading, spacing: 2) {

            // Main content
            VStack(spacing: 40) {
                
                HStack {
                    Text(thought.content)
                        .font(.custom("Manrope-Medium", size: 20))
                        .lineSpacing(4)
                    
                    Spacer()
                }
                
                if let notes = thought.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.custom("Manrope-Regular", size: 14))
                        .lineSpacing(3)
                        .foregroundColor(.secondary)
                }
                
            }
            .multilineTextAlignment(.leading)
            
            VStack(alignment: .leading, spacing: 4) {
                if let journey = thought.chapter {
                    Text(journey.title)
                        .font(.custom("Manrope-Regular", size: 12))
                        .foregroundColor(DesignTokens.Colors.secondaryText)
                } else {
                    Text("nenhum ciclo")
                        .font(.custom("Manrope-Regular", size: 12))
                        .foregroundColor(DesignTokens.Colors.secondaryText)
                }
                
                Text(formatDate(thought.createdDate))
                    .font(.custom("Manrope-Regular", size: 10))
                    .foregroundColor(DesignTokens.Colors.secondaryText)
            }
            .padding(.top, 80)
            
        }
        .padding(.top, 120)
        .padding(.horizontal, 32)
    }
    
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 16) {
            // Edit Button...
            Button(action: {
                showingEditSheet.toggle()
            }) {
                Image(systemName: "pencil")
                    .font(.title2)
            }
            .padding()
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            }
            .clipShape(Circle())
            .background {
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            
            // Share Button...
            Button(action: {
                self.shareThought()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
            }
            .padding()
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            }
            .clipShape(Circle())
            .background {
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            
            // Delete Button...
            Button(action: {
                showingDeleteAlert.toggle()
            }) {
                Image(systemName: "trash")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            .padding()
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            }
            .clipShape(Circle())
            .background {
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }

        }
        .tint(.primary)
    }
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
    
    private func shareThought() {
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
//        // Share implementation here
//        print("Compartilhando: \(shareText)")
    }
}


#Preview {
    let sampleThought = Thought(
        content: "Este é um pensamento dkjsfhasdkjfhas ajkdfhajfdahsl",
        tags: [ThoughtTag(id: .init(),title: "conclusão")],
        shouldRemind: true,
        reminderDate: Date()
    )
    
    ThoughtDetailedView(thought: sampleThought)
}

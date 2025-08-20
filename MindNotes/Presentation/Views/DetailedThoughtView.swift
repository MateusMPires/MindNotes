

import SwiftUI

struct DetailedThoughtView: View {
    
    @Environment(\.modelContext) private var context

    let thought: Thought
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        //Ele cria a de todo mundo...
//        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Main thought card
                    thoughtCard
                    
                    Spacer()
                    
                    if !thought.tags.isEmpty {
                        tagsSection
                    }
                    
                    Spacer()
                    
                    actionButtons
                }
                .padding(24)
            }
            .background(Color(hex: "#131313").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Voltar") {
//                        dismiss()
//                    }
//                    .foregroundColor(.primary)
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Menu {
//                        Button {
//                            shareThought()
//                        } label: {
//                            Label("Compartilhar", systemImage: "square.and.arrow.up")
//                        }
//                        
//                        Button {
//                            showingEditSheet = true
//                        } label: {
//                            Label("Editar", systemImage: "pencil")
//                        }
//                        
//                        Divider()
//                        
//                        Button(role: .destructive) {
//                            showingDeleteAlert = true
//                        } label: {
//                            Label("Excluir", systemImage: "trash")
//                        }
//                    } label: {
//                        Image(systemName: "ellipsis.circle")
//                            .foregroundColor(.primary)
//                    }
//                }
//            }
//        }
        .sheet(isPresented: $showingEditSheet) {
            EditThoughtView(journeys: [], thoughtToEdit: thought, draft: ThoughtDraft(content: thought.content, notes: thought.notes ?? "", createdDate: thought.createdDate, modifiedDate: thought.createdDate, isFavorite: thought.isFavorite, journey: thought.journey))
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
    
    // MARK: - Main Thought Card
    private var thoughtCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header with status indicators
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let journey = thought.journey {
                        Text(journey.name)
                            .font(.custom("Manrope-Regular", size: 12))
                            .foregroundColor(.secondary)
                    } else {
                        Text("em minha mente")
                            .font(.custom("Manrope-Regular", size: 12))
                            .italic()
                            .foregroundColor(.secondary)
                    }
                    
                    Text(formatDate(thought.createdDate))
                        .font(.custom("Manrope-Regular", size: 10))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    if thought.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                    }
                    
                    if thought.shouldRemind {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                            .font(.title3)
                    }
                }
            }
            
            // Main content
            VStack(alignment: .leading, spacing: 16) {
                Text(thought.content)
                    .font(.custom("Manrope-Regular", size: 18))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if let notes = thought.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "note.text")
                            .font(.title3)
                            .foregroundColor(.orange)
                        
                        Text("Notas adicionais")
                            .font(.custom("Manrope-Regular", size: 14))
                            .fontWeight(.medium)
                    }
                    
                    Text(notes)
                        .font(.custom("Manrope-Regular", size: 16))
                        .lineSpacing(3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(24)
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                .background(.white.opacity(0.05))
        }
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        }
    }
    
    // MARK: - Tags Section
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "tag.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("Etiquetas")
                    .font(.custom("Manrope-Regular", size: 14))
                    .fontWeight(.medium)
            }
            
            FlowLayout(spacing: 8) {
                ForEach(thought.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.custom("Manrope-Regular", size: 12))
                        .textCase(.lowercase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(.capsule)
                }
            }
        }
        .padding(20)
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                .background(.blue.opacity(0.05))
        }
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.blue.opacity(0.3), lineWidth: 1)
        }
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
        var shareText = thought.content
        
        if let notes = thought.notes, !notes.isEmpty {
            shareText += "\n\n" + notes
        }
        
        if !thought.tags.isEmpty {
            shareText += "\n\nTags: " + thought.tags.map { "#\($0)" }.joined(separator: " ")
        }
        
        // Share implementation here
        print("Compartilhando: \(shareText)")
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size = CGSize.zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: LayoutSubviews, spacing: CGFloat) {
            var currentPosition = CGPoint.zero
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)
                
                if currentPosition.x + subviewSize.width > maxWidth && currentPosition.x > 0 {
                    currentPosition.x = 0
                    currentPosition.y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(currentPosition)
                currentPosition.x += subviewSize.width + spacing
                lineHeight = max(lineHeight, subviewSize.height)
                size.width = max(size.width, currentPosition.x - spacing)
                size.height = currentPosition.y + lineHeight
            }
        }
    }
}


#Preview {
    let sampleThought = Thought(
        content: "Este é um pensamento de exemplo que demonstra como a view ficará com conteúdo mais longo e detalhado",
        notes: "Algumas notas adicionais que complementam o pensamento principal e fornecem mais contexto",
        tags: ["exemplo", "teste", "minimalismo"],
        shouldRemind: true,
        reminderDate: Date()
    )
    
    DetailedThoughtView(thought: sampleThought)
}

import SwiftUI
import SwiftData

struct TagsView: View {
    @Environment(\.modelContext) private var context
    @Query private var tags: [ThoughtTag]
    
    @State private var newTagTitle: String = ""
    
    @Binding var selectedTags: Set<ThoughtTag>
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Campo para adicionar nova tag
                    HStack {
                        TextField("Adicionar tag...", text: $newTagTitle, onCommit: addTag)
                            .textFieldStyle(.plain)
                            .font(.custom("Manrope-Regular", size: 16))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1))
                    
                    // Retângulo com tags
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                        ForEach(tags) { tag in
                            TagItemView(
                                tag: tag,
                                isSelected: selectedTags.contains(tag)
                            )
                            .onTapGesture {
                                toggleSelection(tag)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("OK") { dismiss() }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { dismiss() }
                    }
                }
            }
        }
    }
    
    private func toggleSelection(_ tag: ThoughtTag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    private func addTag() {
        guard !newTagTitle.isEmpty else { return }
        let newTag = ThoughtTag(id: UUID(), title: newTagTitle)
        context.insert(newTag)
        try? context.save()
        newTagTitle = ""
    }
}


// Componente visual da tag
struct TagItemView: View {
    let tag: ThoughtTag
    let isSelected: Bool
    
    var body: some View {
        Text(tag.title)
            .font(.subheadline)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .accent : .primary)
            .clipShape(Capsule())
    }
}

#Preview {
    TagsView(selectedTags: .constant([]))
}

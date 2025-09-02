import SwiftUI
import SwiftData

struct TagsView: View {
    @Environment(\.modelContext) private var context
    @Query private var tags: [ThoughtTag]   // Busca automática no banco
    
    @State private var newTagTitle: String = ""
    @State private var selectedTags: Set<UUID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Retângulo com tags
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                ForEach(tags) { tag in
                    TagItemView(
                        tag: tag,
                        isSelected: selectedTags.contains(tag.id)
                    )
                    .onTapGesture {
                        toggleSelection(tag)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            
            
            // Campo para adicionar nova tag
            HStack {
                TextField("Adicionar tag...", text: $newTagTitle, onCommit: addTag)
                    .textFieldStyle(.plain)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Tags")
    }
    
    // Alternar seleção
    private func toggleSelection(_ tag: ThoughtTag) {
        if selectedTags.contains(tag.id) {
            selectedTags.remove(tag.id)
        } else {
            selectedTags.insert(tag.id)
        }
    }
    
    // Criar nova tag
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
            .foregroundColor(isSelected ? .blue : .primary)
            .clipShape(Capsule())
    }
}

#Preview {
    TagsView()
}

//
//  TagFilterView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI

struct TagFilterView: View {
    //@EnvironmentObject private var thoughtViewModel: ThoughtViewModel
    @StateObject private var thoughtViewModel: ThoughtViewModel = ThoughtViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if thoughtViewModel.allTags.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma tag encontrada",
                        systemImage: "tag",
                        description: Text("Crie pensamentos com tags para filtrá-los aqui.")
                    )
                } else {
                    Section {
                        ForEach(thoughtViewModel.allTags, id: \.self) { tag in
                            HStack {
                                Button {
                                    thoughtViewModel.toggleTag(tag)
                                } label: {
                                    HStack {
                                        Image(systemName: thoughtViewModel.selectedTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(thoughtViewModel.selectedTags.contains(tag) ? .blue : .secondary)
                                        
                                        Text("#\(tag)")
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(getThoughtCount(for: tag))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.secondary.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } footer: {
                        if !thoughtViewModel.selectedTags.isEmpty {
                            Text("Selecionadas: \(thoughtViewModel.selectedTags.count) tags")
                        }
                    }
                }
            }
            .navigationTitle("Filtrar por Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    if !thoughtViewModel.selectedTags.isEmpty {
                        Button("Limpar Seleção") {
                            thoughtViewModel.clearTagFilters()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    private func getThoughtCount(for tag: String) -> Int {
        return thoughtViewModel.thoughts.filter { $0.tags.contains(tag) }.count
    }
}

#Preview {
    TagFilterView()
        .environmentObject(ThoughtViewModel())
}

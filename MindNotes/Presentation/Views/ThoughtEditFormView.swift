//
//  EditThoughtView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 15/08/25.
//


import SwiftUI
import SwiftData

// Preciso de: Pensamento a ser editado...

struct ThoughtEditFormView: View {
   
    // SwiftData...
    @Environment(\.modelContext) private var context
    
    let journeys: [Journey]

    // NewThoughtView States...
    let thoughtToEdit: Thought
    
    @State var draft: ThoughtDraft = ThoughtDraft()
    
    @State private var notes: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var newTag: String = ""
    @State private var showingJourneyPicker = false
    
    @FocusState private var isContentFocused: Bool
    
    // Função Void OnEdit
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                AppBackground()
                
                Form {
                    // Content Section
                    Section {
                        TextField("O que você está pensando?", text: $draft.content , axis: .vertical)
                            .lineLimit(3...8)
                            .font(.body)
                            .focused($isContentFocused)
                        
                        TextField("Notas adicionais...", text: $notes, axis: .vertical)
                            .lineLimit(2...6)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    } footer: {
                        Text("Compartilhe suas reflexões, ideias e momentos de insight.")
                    }
                    
                    //Details Section...
                    Section {
                        NavigationLink {
                            OtherEditView(draft: $draft) {
                                editThought()
                            }
                        }
                        label: {
                            Text("Detalhes")
                        }
                    }
                    
                    
                    // Journey Section...
                    Section {
                        Picker(selection: $draft.chapter ) {
                            if journeys.isEmpty {
                                ContentUnavailableView("Sem jornadas por enquanto...", image: "")
                            } else {
                                Text("Nenhuma jornada")
                                    .tag(nil as Journey?)
                                
                                ForEach(journeys, id: \.self) { journey in
                                    Text(journey.title)
                                        .tag(journey)
                                }
                            }
                        } label: {
                            Text("Jornada")
                        }
                        .pickerStyle(.navigationLink)
                    }
                }
                .navigationTitle("Editar Pensamento")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salvar") {
                            editThought()
                        }
                        .fontWeight(.bold)
                        .disabled(draft.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }
//    
//    private func addTag() {
//        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
//        if !trimmedTag.isEmpty && !draft.tagsId.contains(trimmedTag) {
//            draft.tags.append(trimmedTag)
//            newTag = ""
//        }
//    }
    
    private func removeTag(_ tag: String) {
        //tags.removeAll { $0 == tag }
    }
    
    private func editThought() {
        let trimmedContent = draft.content.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create new thought
        
        thoughtToEdit.content = trimmedContent
        thoughtToEdit.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
        thoughtToEdit.tags = Array(draft.tags)
        thoughtToEdit.shouldRemind = draft.shouldRemind
        thoughtToEdit.reminderDate = draft.shouldRemind ? draft.reminderDate : nil
        thoughtToEdit.createdDate = draft.createdDate
        thoughtToEdit.isFavorite = draft.isFavorite
        thoughtToEdit.chapter = draft.chapter
                
        do {
            try context.save()
        } catch {
            
        }
        dismiss()
    }
}

struct OtherEditView: View {
    
    @Binding var draft: ThoughtDraft
    
    @State private var newTag: String = ""
    
    
    // Closure que será passada pelo OtherView
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack {
            Form {
                // Tags Section
                Section("Etiquetas") {
//                    if !draft.tags.isEmpty {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 8) {
//                                ForEach(draft.tags, id: \.self) { tag in
//                                    HStack(spacing: 4) {
//                                        Text("#\(tag)")
//                                            .font(.caption)
//                                        
//                                        Button {
//                                            //removeTag(tag)
//                                        } label: {
//                                            Image(systemName: "xmark")
//                                                .font(.caption2)
//                                        }
//                                    }
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 6)
//                                    .background(Color.blue.opacity(0.2))
//                                    .foregroundColor(.blue)
//                                    .clipShape(Capsule())
//                                }
//                            }
//                            .padding(.horizontal, 1)
//                        }
//                    }
//                    
                    HStack {
                        TextField("Nova etiqueta", text: $newTag)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .onSubmit {
                                //addTag()
                            }
                        
                        if !newTag.isEmpty {
                            Button("Adicionar") {
                                //addTag()
                            }
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                        }
                    }
                }
                
                // Date Section
                Section("Data e Hora") {
                    DatePicker("", selection: $draft.createdDate, in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                    
                }
                
                // Reminder Section
                Section {
                    Toggle(isOn: $draft.shouldRemind) {
                        Label("Lembrete futuro", systemImage: "bell.fill")
                            .foregroundStyle(.orange)
                    }
                    
                    if draft.shouldRemind {
                        DatePicker("Lembrar em", selection: $draft.reminderDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }
                } footer: {
                    if draft.shouldRemind {
                        Text("Você receberá uma notificação para relembrar este pensamento.")
                    }
                }
                
                // Favorite Section
                Section {
                    Toggle(isOn: $draft.isFavorite) {
                        Label("Favorito", systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    onSave?()
                } label: {
                    Text("Salvar")
                }
                .bold()
                .disabled(draft.content.isEmpty)

            }
        }
    }
    
//    private func addTag() {
//        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
//        if !trimmedTag.isEmpty && !draft.tags.contains(trimmedTag) {
//            draft.tags.append(trimmedTag)
//            newTag = ""
//        }
//    }
//    
//    private func removeTag(_ tag: String) {
//        draft.tags.removeAll { $0 == tag }
//    }
}

//#Preview {
//    NewThoughtView()
//        //.environmentObject(ThoughtViewModel())
//}

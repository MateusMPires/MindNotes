//
//  NewThoughtView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

struct NewThoughtView: View {
   
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // Receber journeys como parâmetro
    let journeys: [Journey]
    
    // NewThoughtView States...
    @State var draft: ThoughtDraft = ThoughtDraft()
    @State private var notes: String = ""
    @State private var newTag: String = ""
    @State private var showingJourneyPicker = false
    
    // Inicializador que recebe os journeys
    init(journeys: [Journey] = []) {
        self.journeys = journeys
    }
        
    var body: some View {
        NavigationStack {
            Form {
                // Content Section
                Section {
                    TextField("O que você está pensando?", text: $draft.content, axis: .vertical)
                        .lineLimit(3...8)
                        .font(.body)
                    
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
                        OtherView(draft: $draft) {
                            saveThought()
                        }
                    } label: {
                        Text("Detalhes")
                    }
                }
                
                // Journey Section - Usando journeys recebidos como parâmetro
                Section("Jornada") {
                    if journeys.isEmpty {
                        Text("Minha Mente")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Jornada", selection: $draft.journey) {
                            Text("Minha Mente")
                                .tag(nil as Journey?)
                            
                            ForEach(journeys, id: \.self) { journey in
                                Text("\(journey.emoji) \(journey.name)")
                                    .tag(journey as Journey?)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                }
            }
            .navigationTitle("Novo Pensamento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Criar") {
                        saveThought()
                    }
                    .fontWeight(.bold)
                    .disabled(draft.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        // Removido .task pois não precisamos mais buscar journeys
    }
    
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !draft.tags.contains(trimmedTag) {
            draft.tags.append(trimmedTag)
            newTag = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        draft.tags.removeAll { $0 == tag }
    }
    
    private func saveThought() {
        let trimmedContent = draft.content.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create new thought
        let newThought = Thought(
            content: trimmedContent,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            tags: draft.tags,
            shouldRemind: draft.shouldRemind,
            reminderDate: draft.shouldRemind ? draft.reminderDate : nil,
            journey: draft.journey
        )
        
        print(newThought.journey)
        
        // Definir data de criação se especificada
        if draft.createdDate != Date() {
            newThought.createdDate = draft.createdDate
        }
        
        newThought.isFavorite = draft.isFavorite
        
        context.insert(newThought)
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar pensamento: \(error)")
        }
        
        dismiss()
    }
}

struct OtherView: View {
    
    @Binding var draft: ThoughtDraft
    @State private var newTag: String = ""
    
    // Closure que será passada pelo OtherView
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack {
            Form {
                // Tags Section
                Section("Etiquetas") {
                    if !draft.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(draft.tags, id: \.self) { tag in
                                    HStack(spacing: 4) {
                                        Text("#\(tag)")
                                            .font(.caption)
                                        
                                        Button {
                                            removeTag(tag)
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.caption2)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                    }
                    
                    HStack {
                        TextField("Nova etiqueta", text: $newTag)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .onSubmit {
                                addTag()
                            }
                        
                        if !newTag.isEmpty {
                            Button("Adicionar") {
                                addTag()
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
                    Text("Criar")
                }
                .bold()
                .disabled(draft.content.isEmpty)
            }
        }
    }
    
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !draft.tags.contains(trimmedTag) {
            draft.tags.append(trimmedTag)
            newTag = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        draft.tags.removeAll { $0 == tag }
    }
}

// MARK: - Exemplos de uso na view pai

struct ParentView: View {
    @Query(sort: \Journey.createdDate, order: .forward) var journeys: [Journey]
    @State private var showingNewThought = false
    
    var body: some View {
        VStack {
            Button("Novo Pensamento") {
                showingNewThought = true
            }
        }
        .sheet(isPresented: $showingNewThought) {
            // Passar os journeys como parâmetro
            NewThoughtView(journeys: journeys)
        }
    }
}

// Ou usando NavigationLink
struct AnotherParentView: View {
    @Query(sort: \Journey.createdDate, order: .forward) var journeys: [Journey]
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Criar Pensamento") {
                    NewThoughtView(journeys: journeys)
                }
            }
        }
    }
}

#Preview {
    NewThoughtView(journeys: [])
}

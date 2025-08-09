//
//  NewThoughtView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

struct NewThoughtView: View {
    let journey: Journey?
    let thoughtToEdit: Thought?
    
    @EnvironmentObject private var thoughtViewModel: ThoughtViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var content: String = ""
    @State private var notes: String = ""
    @State private var selectedJourney: Journey?
    @State private var tags: [String] = []
    @State private var shouldRemind: Bool = false
    @State private var reminderDate = Date()
    @State private var isFavorite: Bool = false
    @State private var thoughtDate = Date()
    @State private var newTag: String = ""
    @State private var showingJourneyPicker = false
    
    @FocusState private var isContentFocused: Bool
    @Query private var allJourneys: [Journey]
    
    private var isEditing: Bool {
        thoughtToEdit != nil
    }
    
    init(journey: Journey? = nil, thoughtToEdit: Thought? = nil) {
        self.journey = journey
        self.thoughtToEdit = thoughtToEdit
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Content Section
                Section {
                    TextField("O que você está pensando?", text: $content, axis: .vertical)
                        .lineLimit(3...8)
                        .font(.body)
                        .focused($isContentFocused)
                    
                    TextField("Notas adicionais...", text: $notes, axis: .vertical)
                        .lineLimit(2...6)
                        .font(.callout)
                        .foregroundColor(.secondary)
                } header: {
                    Text("Pensamento")
                } footer: {
                    Text("Compartilhe suas reflexões, ideias e momentos de insight.")
                }
                
                // Journey Section
                Section("Jornada") {
                    Button {
                        showingJourneyPicker = true
                    } label: {
                        HStack {
                            if let selectedJourney = selectedJourney {
                                Text(selectedJourney.emoji)
                                    .font(.title3)
                                    .frame(width: 28, height: 28)
                                    .background(Color(hex: selectedJourney.colorHex).opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                
                                Text(selectedJourney.name)
                                    .foregroundColor(.primary)
                            } else {
                                Image(systemName: "folder")
                                    .foregroundColor(.secondary)
                                    .frame(width: 28, height: 28)
                                
                                Text("Selecionar jornada")
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                // Tags Section
                Section("Etiquetas") {
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
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
                    DatePicker("Quando isso aconteceu?", selection: $thoughtDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }
                
                // Reminder Section
                Section {
                    Toggle(isOn: $shouldRemind) {
                        Label("Lembrete futuro", systemImage: "bell.fill")
                            .foregroundStyle(.orange)
                    }
                    
                    if shouldRemind {
                        DatePicker("Lembrar em", selection: $reminderDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }
                } footer: {
                    if shouldRemind {
                        Text("Você receberá uma notificação para relembrar este pensamento.")
                    }
                }
                
                // Favorite Section
                Section {
                    Toggle(isOn: $isFavorite) {
                        Label("Favorito", systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .navigationTitle(isEditing ? "Editar Pensamento" : "Novo Pensamento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Salvar" : "Criar") {
                        saveThought()
                    }
                    .fontWeight(.semibold)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $showingJourneyPicker) {
                JourneyPickerView(selectedJourney: $selectedJourney)
            }
            .onAppear {
                setupInitialState()
                if !isEditing {
                    isContentFocused = true
                }
            }
        }
    }
    
    private func setupInitialState() {
        if let thoughtToEdit = thoughtToEdit {
            // Editing existing thought
            content = thoughtToEdit.content
            notes = thoughtToEdit.notes ?? ""
            selectedJourney = thoughtToEdit.journey
            tags = thoughtToEdit.tags
            shouldRemind = thoughtToEdit.shouldRemind
            reminderDate = thoughtToEdit.reminderDate ?? Date()
            isFavorite = thoughtToEdit.isFavorite
            thoughtDate = thoughtToEdit.createdDate
        } else {
            // New thought
            selectedJourney = journey
            thoughtDate = Date()
        }
    }
    
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            newTag = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func saveThought() {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isEditing, let thoughtToEdit = thoughtToEdit {
            // Update existing thought
            thoughtToEdit.content = trimmedContent
            thoughtToEdit.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
            thoughtToEdit.journey = selectedJourney
            thoughtToEdit.tags = tags
            thoughtToEdit.shouldRemind = shouldRemind
            thoughtToEdit.reminderDate = shouldRemind ? reminderDate : nil
            thoughtToEdit.isFavorite = isFavorite
            thoughtViewModel.updateThought(thoughtToEdit)
        } else {
            // Create new thought
            thoughtViewModel.createThought(
                content: trimmedContent,
                notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
                tags: tags,
                shouldRemind: shouldRemind,
                reminderDate: shouldRemind ? reminderDate : nil
            )
        }
        
        dismiss()
    }
}

struct JourneyPickerView: View {
    @Binding var selectedJourney: Journey?
    @Environment(\.dismiss) private var dismiss
    @Query private var journeys: [Journey]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        selectedJourney = nil
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: selectedJourney == nil ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedJourney == nil ? .blue : .secondary)
                            
                            Text("Sem jornada")
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                if !journeys.filter({ !$0.isArchived }).isEmpty {
                    Section("Jornadas") {
                        ForEach(journeys.filter { !$0.isArchived }) { journey in
                            Button {
                                selectedJourney = journey
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: selectedJourney?.id == journey.id ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedJourney?.id == journey.id ? .blue : .secondary)
                                    
                                    Text(journey.emoji)
                                        .font(.title3)
                                        .frame(width: 28, height: 28)
                                        .background(Color(hex: journey.colorHex).opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                    Text(journey.name)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("\(journey.thoughtCount)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Selecionar Jornada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Concluído") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    NewThoughtView()
        .environmentObject(ThoughtViewModel())
}
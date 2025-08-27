//
//  NewThoughtView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

// Preciso de: Jornadas disponíveis para o novo pensamento...


struct ThoughtFormView: View {
   
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Journey.createdDate, order: .forward) private var journeys: [Journey]

    @EnvironmentObject var thoughtService: ThoughtService
    
    // Receber journeys e namespace como parâmetros
   // let journeys: [Journey]
    let imageButton: String
    let transitionNamespace: Namespace.ID
    
    
    // NewThoughtView States...
    @State var draft: ThoughtDraft = ThoughtDraft()
    @State private var notes: String = ""
    @State private var newTag: String = ""
    @State private var showingJourneyPicker = false
    @State private var showAnimation = false
    
  
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                AppBackground()
               
                VStack(spacing: 60) {
                    // Header com ícone que faz transição
                    headerWithTransition
                   
                    // Formulário principal
                    mainFormView
                }
               
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationTransition(.zoom(sourceID: imageButton, in: transitionNamespace))
        .tint(.primary)

    }
    
    private var headerWithTransition: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancelar") {
                    withAnimation(.spring(duration: 0.1)) {
                        showAnimation = false
                    }
                    
                        dismiss()
                    
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                // Ícone que faz a transição
                ZStack {
                    Image(imageButton)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .matchedTransitionSource(id: imageButton, in: transitionNamespace)
                    
                    // Ícone no centro
                    Image(systemName: "leaf")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .hidden()
                }
               
                
                Spacer()
                
                Button("Criar") {
                    // Haptic feedback antes de executar onSave
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                    

                    saveThought()
                }
                .fontWeight(.bold)
                .disabled(draft.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    private var mainFormView: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Campo de notas
                VStack(alignment: .leading, spacing: 16) {
                    
                    TextField("Pensamento", text: $draft.content, axis: .vertical)
                        .lineLimit(2...4)
                        .font(.custom("Manrope-Regular", size: 16))
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.05))
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                    TextField("Notas", text: $notes, axis: .vertical)
                        .lineLimit(4...6)
                        .font(.custom("Manrope-Regular", size: 16))
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.05))
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                }
                
                
                // Seção de Jornada
                if !journeys.isEmpty {
                    
                    Divider()
                    
                    Picker("Jornada", selection: $draft.chapter) {
                        Text("Minha Mente")
                            .tag(nil as Journey?)
                        
                        ForEach(journeys, id: \.self) { journey in
                            Text("\(journey.icon) \(journey.title)")
                                .tag(journey as Journey?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                    
                }
                
                Divider()


                // Botão para detalhes
                NavigationLink {
                    OtherView(draft: $draft) {
                        saveThought()
                    }
                } label: {
                    HStack {
                        Text("Detalhes")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                }
                .foregroundColor(.primary)
                
                Spacer(minLength: 50)
            }
        }
    }
    
    private func saveThought() {
        
        do {
            try thoughtService.saveThought(draft, notes: notes)
        } catch {
            
        }
        
        withAnimation(.spring(duration: 0.1)) {
            showAnimation = false
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
        ZStack {
            AppBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Tags Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Etiquetas")
//                            .font(.headline)
//                        
//                        if !draft.tagsId.isEmpty {
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: 8) {
//                                    ForEach(draft.tags, id: \.self) { tag in
//                                        HStack(spacing: 4) {
//                                            Text("#\(tag)")
//                                                .font(.caption)
//                                            
//                                            Button {
//                                               // removeTag(tag)
//                                            } label: {
//                                                Image(systemName: "xmark")
//                                                    .font(.caption2)
//                                            }
//                                        }
//                                        .padding(.horizontal, 10)
//                                        .padding(.vertical, 6)
//                                        .background(Color.blue.opacity(0.2))
//                                        .foregroundColor(.blue)
//                                        .clipShape(Capsule())
//                                    }
//                                }
//                                .padding(.horizontal, 1)
//                            }
//                        }
//                        
//                        HStack {
//                            TextField("Nova etiqueta", text: $newTag)
//                                .textInputAutocapitalization(.never)
//                                .autocorrectionDisabled()
//                                .onSubmit {
//                                    //addTag()
//                                }
//                                .padding()
//                                .background {
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(.white.opacity(0.05))
//                                }
//                            
//                            if !newTag.isEmpty {
//                                Button("Adicionar") {
//                                    //addTag()
//                                }
//                                .foregroundColor(.blue)
//                                .fontWeight(.medium)
//                            }
//                        }
//                    }
//                    
//                    // Date Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Data e Hora")
//                            .font(.headline)
//                        
//                        DatePicker("", selection: $draft.createdDate, in: ...Date(), displayedComponents: [.date])
//                            .datePickerStyle(.graphical)
//                            .padding()
//                            .background {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .fill(.white.opacity(0.05))
//                            }
//                    }
//                    
//                    // Reminder Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        Toggle(isOn: $draft.shouldRemind) {
//                            Label("Lembrete futuro", systemImage: "bell.fill")
//                                .foregroundStyle(.orange)
//                        }
//                        .padding()
//                        .background {
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(.white.opacity(0.05))
//                        }
//                        
//                        if draft.shouldRemind {
//                            DatePicker("Lembrar em", selection: $draft.reminderDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
//                                .datePickerStyle(.compact)
//                                .padding()
//                                .background {
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .fill(.white.opacity(0.05))
//                                }
//                            
//                            Text("Você receberá uma notificação para relembrar este pensamento.")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    
//                    // Favorite Section
//                    Toggle(isOn: $draft.isFavorite) {
//                        Label("Favorito", systemImage: "star.fill")
//                            .foregroundStyle(.yellow)
//                    }
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(.white.opacity(0.05))
//                    }
                }
                .padding()
            }
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    // Haptic feedback antes de executar onSave
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                    
                    onSave?()
                } label: {
                    Text("Criar")
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

#Preview {
    @Previewable @Namespace var namespace
    ThoughtFormView(imageButton: "mainButton", transitionNamespace: namespace)
}

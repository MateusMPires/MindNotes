//
//  NewThoughtView.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import SwiftUI
import SwiftData

// Preciso de: Jornadas disponíveis para o novo pensamento...

struct ActionItem {
    let icon: String
    let action: () -> Void
}

enum ThoughtDestination: Hashable {
    case details
}


struct ThoughtFormView: View {
   
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var thoughtService: ThoughtService
    let journeys: [Journey]
    
    // NewThoughtView States...
    @State var draft: ThoughtDraft = ThoughtDraft()
    @State private var notes: String = ""
    
    @State private var destination: ThoughtDestination?

    @State private var showTagView: Bool = false
    
    @FocusState private var keyboardIsFocused: Bool
    
    private var actions: [ActionItem] {
        [
            ActionItem(icon: "info") {
                destination = .details
            },
            ActionItem(icon: "star") {
                print("Favoritar")
            },
            ActionItem(icon: "wave.3.right") {
                print("Ecoar")
            }
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                AppBackground()
               
                ScrollView {
                   
                    VStack(alignment: .center) {
                        
                        // Pensamento principal...
                        TextField("pensamento...", text: $draft.content, axis: .vertical)
                            .focused($keyboardIsFocused)
                            .lineLimit(2...4)
                            .font(.custom("Manrope-SemiBold", size: 20))
                            .padding()
                            
                        
                        // Notas...
                        TextField("notas...", text: $notes, axis: .vertical)
                            .lineLimit(4...6)
                            .font(.custom("Manrope-Regular", size: 16))
                            .foregroundStyle(.secondary)
                            .padding()
                        
                        // Actions...
                        HStack(spacing: 24) {
                            
                            NavigationLink {
                                ThoughtInfoFormView(draft: $draft) {
                                    saveThought()
                                }
                            } label: {
                                
                                Image(systemName: "info")
                                    .font(DesignTokens.Typography.body)
                                    .tint(.primary)
                                    .padding(8)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .stroke(.black, lineWidth: 1)
                                    }
                            }
                            
                            Button {
                                showTagView.toggle()
                            } label: {
                                Image(systemName: "number")
                                    .font(DesignTokens.Typography.body)
                                    .tint(.primary)
                                    .padding(5)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .stroke(.black, lineWidth: 1)
                                    }
                            }
                        }
                        .padding(.top, 32)
                            
                    }
                    .padding(.top, 120)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        keyboardIsFocused = true
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showTagView, content: {
                TagsView()
            })
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction) {
                    
                    Button("Salvar") {
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
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            })
            
        }
        .tint(.accent)
    }
    
    private func saveThought() {
        
        do {
            try thoughtService.saveThought(draft, notes: notes)
        } catch {
            
        }
        
        dismiss()
    }
}

struct ThoughtInfoFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                    // Date Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Data e Hora")
                            .font(.headline)
                        
                        DatePicker("", selection: $draft.createdDate, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.05))
                            }
                    }

                    // Reminder Section
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $draft.shouldRemind) {
                            Label("Eco", systemImage: "wave.3.right")
                                .foregroundStyle(DesignTokens.Colors.primaryText)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.05))
                        }
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
                    }
                    
                    // Favorite Section
                    Toggle(isOn: $draft.isFavorite) {
                        Label("Favoritar", systemImage: "star.fill")
                            .foregroundStyle(DesignTokens.Colors.primaryText)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                    }
                }
                .padding()
            }
        }
        .tint(.accentColor)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    // Haptic feedback antes de executar onSave
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                    
                    onSave?()
                    dismiss()
                    
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

#Preview {
    ThoughtFormView(journeys: Journey.mockData)
}

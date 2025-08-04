//
//  NewThought.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 28/07/25.
//

import SwiftUI

struct NewThought: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @Environment(\.dismiss) var dismiss
    @State var showTagSheet: Bool = false
    @FocusState private var isMainThoughtFocused: Bool

    @State var isEditing: Bool = false
    
    @State private var mainThought: String = ""
    @State private var additionalNotes: String = ""
    @State private var selectedTag: String = ""
    @State private var customTag: String = ""
    @State private var shouldRemind: Bool = false
    @State private var reminderDate = Date()
    @State private var isFavorited: Bool = false
    @State private var thoughtDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                // Pensamento e Notas
                Section {
                    TextField("Pensamento...", text: $mainThought, axis: .vertical)
                        .lineLimit(3...6)
                        .font(.body)
                        .focused($isMainThoughtFocused)
                    
                    TextField("Notas e detalhes...", text: $additionalNotes, axis: .vertical)
                        .lineLimit(2...8)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                // Etiquetas
                Section {
                    Button {
                        showTagSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "number")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .frame(width: 28, height: 28)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            
                            Text("Etiquetas")
                            Spacer()
                            if !selectedTag.isEmpty {
                                Text("#\(selectedTag)")
                                    .foregroundStyle(.secondary)
                            }
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                    .foregroundStyle(.primary)
                }
                
                // Data
                Section {
                    DatePicker("", selection: $thoughtDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                // Lembrete
                Section {
                    Toggle(isOn: $shouldRemind) {
                        Label("Lembre-me", systemImage: "bell.fill")
                            .foregroundStyle(.orange)
                    }
                    
                    if shouldRemind {
                        DatePicker("Data do lembrete", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }

                // Favorito
                Section {
                    Toggle(isOn: $isFavorited) {
                        Label("Favorito", systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .navigationTitle(isEditing ? "Editar Pensamento" : "Novo Pensamento")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showTagSheet) {
                TagView(showSheet: $showTagSheet)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") {
                        saveThought()
                    }
                    .foregroundColor(.blue)
                    .bold()
                    .disabled(mainThought.isEmpty)
                }
            }
            .onAppear {
                isMainThoughtFocused = true
            }
        }
    }
    
    private func saveThought() {
            // Cria novo
            let new = Thought(
                thought: mainThought,
                date: thoughtDate,
                isFavorite: isFavorited,
                shouldRemind: shouldRemind
            )
            viewModel.addThought(new)
        
        
        dismiss()
    }
}


//TODO: Tem que ter um lugar pra gerenciar as tags
//TODO:
struct TagView: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("#DJF")
                        .font(.callout)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                TextField("Adicionar Nova Etiqueta...", text: .constant(""))
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                       // Confirmation Action...
                        
                    } label: {
                        Text("OK")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                       // Cancellation Action...
                        showSheet.toggle()
                    } label: {
                        Text("Cancelar")
                    }
                }

            }
        }
    }
}
#Preview {
    let viewModel = MainViewModel()
    NewThought(viewModel: viewModel)
    
    //TagView(showSheet: .constant(true))
}

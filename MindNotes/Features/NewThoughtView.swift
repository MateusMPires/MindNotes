//
//  NewThought.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 28/07/25.
//

import SwiftUI

struct NewThought: View {
    
    @Binding var isShowing: Bool
    
    @State var showSheet: Bool = false
    
    @State private var mainThought: String = ""
    @State private var additionalNotes: String = ""
    @State private var selectedTag: String = ""
    @State private var customTag: String = ""
    @State private var shouldRemind: Bool = false
    @State private var reminderDate = Date()
    @State private var isFavorited: Bool = false
    @State private var thoughtDate = Date()
    @State private var showingDatePicker = false
    
    private let predefinedTags = ["Reflexão", "Versículo", "Lembrete", "Inspiração", "Gratidão", "Oração"]
    
    var body: some View {
        NavigationStack {
            Form {
                // Seção principal do pensamento
                Section {
                    TextField("Escreva seu pensamento..", text: $mainThought, axis: .vertical)
                        .lineLimit(3...6)
                        .font(.body)
                    
                    TextField("Detalhes e notas...", text: $additionalNotes, axis: .vertical)
                        .lineLimit(2...8)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                // Navegação pra tela de Etiquetas
                Section {
                    Button {
                        // Go to TagView...
                        showSheet.toggle()
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
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                               
                        }
                    }
                    .padding(8)
                    .foregroundStyle(.primary)
                }
                
                // Seção de data e hora
                Section {
                    DatePicker("", selection: $thoughtDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                // Seção de lembrete
                Section {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .frame(width: 28, height: 28)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        Text("Lembre-me")
                        
                        Toggle("", isOn: $shouldRemind)
                    }
                }
            }
            .navigationTitle("Novo Pensamento")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheet, content: {
                TagView(showSheet: $showSheet)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        // Ação de cancelar
                        isShowing.toggle()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") {
                        // Ação de salvar
                        saveThought()
                    }
                    .foregroundColor(.blue)
                    .bold()
                    .disabled(mainThought.isEmpty)
                }
            }
        }
    }
    
    private func saveThought() {
        // Lógica para salvar o pensamento
        let finalTag = selectedTag == "custom" ? customTag : selectedTag
        
        print("Pensamento: \(mainThought)")
        print("Notas adicionais: \(additionalNotes)")
        print("Tag: \(finalTag)")
        print("Data: \(thoughtDate)")
        print("Lembrete: \(shouldRemind ? reminderDate.description : "Não")")
        print("Favorito: \(isFavorited)")
    }
}

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
                        showSheet.toggle()
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
    NewThought(isShowing: .constant(true))
    
    //TagView(showSheet: .constant(true))
}

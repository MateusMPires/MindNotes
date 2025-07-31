//
//  NewThought.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 28/07/25.
//

import SwiftUI

struct NewThought: View {
    
    @Binding var isShowing: Bool
    
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
                
                // Seção de etiqueta
                          Section {
                              HStack {
                                  Image(systemName: "number")
                                      .foregroundColor(.white)
                                      .font(.subheadline)
                                      .frame(width: 28, height: 28)
                                      .background(Color.gray)
                                      .clipShape(RoundedRectangle(cornerRadius: 4))
                                  Picker("Etiqueta", selection: $selectedTag) {
                                      Text("Nenhuma").tag("")
                                      ForEach(predefinedTags, id: \.self) { tag in
                                          Text(tag).tag(tag)
                                      }
                                      Text("Personalizada").tag("custom")
                                  }
                                  .pickerStyle(.navigationLink)
                              }
                              if selectedTag == "custom" {
                                  TextField("Digite sua etiqueta", text: $customTag)
                                      .font(.callout)
                              }
                          }
                          
                // Seção de data e hora
                Section {
                   // HStack {
                        //Text("Data e hora")
                        //    .foregroundColor(.primary)
                        
                       // Spacer()
                        
                        DatePicker("", selection: $thoughtDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                            .labelsHidden()
//                        Button(action: {
//                            showingDatePicker.toggle()
//                        }) {
//                            Text(thoughtDate.formatted(date: .abbreviated, time: .shortened))
//                                .foregroundColor(.blue)
//                        }
                    //}
                    
                    //if showingDatePicker {
//                        DatePicker("", selection: $thoughtDate, displayedComponents: [.date, .hourAndMinute])
//                            .datePickerStyle(.compact)
//                            .labelsHidden()
                    //}
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

#Preview {
    NewThought(isShowing: .constant(true))
}

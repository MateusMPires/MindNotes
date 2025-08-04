//
//  HomeView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 17/07/25.
//

import SwiftUI

//TODO: Mostrar frases com aspas

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Header com filtro
                    HStack {
                        Button(action: {
                            // Ação do filtro
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Indicador do mês
                    HStack {
                        Text("Junho")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Lista de pensamentos
                    List {
                        // Pensamento clicável
                        // Adicione mais pensamentos aqui..
                        //TODO: Colocar entre parênteses as frases.
                        ForEach(viewModel.thoughts, id: \.id) { thought in
                         
                                ThoughtView(
                                    thought: thought.thought,
                                    dateTime: "11/06/1012 às 09:30",
                                    tag: "Lembrete"
                                )
                                //.padding(.horizontal)
                                .overlay(
                                    NavigationLink(
                                        destination: DetailedThoughtView(
                                            thought: thought.thought,
                                            dateTime: "11/06/1012 às 09:30",
                                            tag: "Lembrete",
                                            additionalNotes: "Focar nos conceitos de State, Binding e Navigation."
                                        )
                                    ) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                )
                                //.contentShape(Rectangle())

                            
                            .buttonStyle(PlainButtonStyle())
                            .swipeActions(edge: .trailing) {
                                Button("Excluir") {
                                    // Ação de excluir
                                }
                                .tint(.red)
                                
                                Button("Favoritar") {
                                    // Ação de favoritar
                                }
                                .tint(.yellow)
                            }
                            .swipeActions(edge: .leading) {
                                Button("Compartilhar") {
                                    // Ação de compartilhar
                                }
                                .tint(.green)
                                
                                Button("Editar") {
                                    // Ação de editar
                                }
                                .tint(.blue)
                            }
                            
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showSheet) {
               NewThought(viewModel: viewModel)
            }
            .toolbar {
                // Aqui eu quero um header pra eu poder filtrar e classificar todos os pensamentos.
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                            Text("Novo pensamento")
                        }
                        .bold()
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Meus pensamentos")
        }
    }
}

#Preview {
    MainView()
}

/*
 Talvez colocar as etiquetas pra direita.
 Colocar a bolinha do dia, e ter um divisor de mês na lista
 */
struct ThoughtView: View {
    let thought: String
    let dateTime: String
    let tag: String
    @State private var isFavorited: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header com tag e botão de favoritar
            
            HStack {
                // Conteúdo do pensamento
                Text(thought)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFavorited.toggle()
                    }
                }) {
                    Image(systemName: isFavorited ? "star.fill" : "star")
                        .foregroundColor(isFavorited ? .yellow : .gray)
                        .font(.title3)
                }
            }

            HStack {
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
                
               
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        //.clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

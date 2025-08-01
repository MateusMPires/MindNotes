//
//  HomeView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 17/07/25.
//

import SwiftUI

struct HomeView: View {
    
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
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
                    LazyVStack(spacing: 12) {
                        // Pensamento clicável
                        // Adicione mais pensamentos aqui..
                        //TODO: Colocar entre parênteses as frases.
                        NavigationLink(destination: DetailedThoughtView(
                            thought: "Lembrar de estudar SwiftUI hoje",
                            dateTime: "11/06/1012 às 09:30",
                            tag: "Lembrete",
                            additionalNotes: "Focar nos conceitos de State, Binding e Navigation. Praticar com projetos pequenos."
                        )) {
                            ThoughtView(
                                thought: "Lembrar de estudar SwiftUI hoje",
                                dateTime: "11/06/1012 às 09:30",
                                tag: "Lembrete"
                            )
                            .padding(.horizontal)
                        }
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
                        
                        // Adicione mais pensamentos aqui...
                        NavigationLink(destination: DetailedThoughtView(
                            thought: "Lembrar de estudar SwiftUI hoje",
                            dateTime: "11/06/1012 às 09:30",
                            tag: "Lembrete",
                            additionalNotes: "Focar nos conceitos de State, Binding e Navigation. Praticar com projetos pequenos."
                        )) {
                            ThoughtView(
                                thought: "Lembrar de estudar SwiftUI hoje",
                                dateTime: "11/06/1012 às 09:30",
                                tag: "Lembrete"
                            )
                            .padding(.horizontal)
                        }
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
                .padding(.vertical)
            }
            .sheet(isPresented: $showSheet, content: {
                NewThought(isShowing: $showSheet)
            })
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
    HomeView()
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
                //                Circle()
                //                    .stroke(style: StrokeStyle(lineWidth: 2))
                //                    .foregroundStyle(.gray.opacity(0.3))
                //                    .frame(width: 32, height: 32)
                //                    .overlay {
                //                        Text("12")
                //                    }
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
            // Data e hora
            //            Text(dateTime)
            //                .font(.caption)
            //                .foregroundColor(.secondary)
            //                .italic()
            //                .hidden()
            
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
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

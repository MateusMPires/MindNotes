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
    @State private var isFirstSectionExpanded = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // Title with date...
                    VStack {
                        Text("MONDAY, APRIL 7, 2025")
                            .font(.caption2)
                        
                        Text("Olá Mateus!")
                            .font(.largeTitle)
                    }
                    
                    // Filter rectangles...
                    //                HStack {
                    //                    Text("Futuro eu")
                    //                        .padding()
                    //                        .frame(maxWidth: .infinity)
                    //                        .background {
                    //                            RoundedRectangle(cornerRadius: 8)
                    //                                .fill(Color.gray.opacity(0.2))
                    //                                //.frame(maxWidth: .infinity)
                    //                        }
                    //
                    //                    Spacer()
                    //
                    //                    Text("Todos")
                    //                        .padding()
                    //                        .frame(maxWidth: .infinity)
                    //                        .background {
                    //                            RoundedRectangle(cornerRadius: 8)
                    //                                .fill(Color.gray.opacity(0.2))
                    //                        }
                    //                }
                    //                .padding()
                    
                    // Teste...
//                    VStack(spacing: 16) {
//                        
//                        Image(systemName: "bell.fill")
//                            .font(.callout)
//                        
//                        Text("se lembre")
//                            .textCase(.uppercase)
//                            .font(.caption2)
//                        
//                        Text("dskjfhaskjdhfjakfhaskjdhfakjsdhfakjddsmfsdmhfshjdgfsjhadgfsodijshfkajs")
//                            .multilineTextAlignment(.center)
//                        
//                        Text("Criado dia 09/02/2023")
//                            .font(.caption2)
//                    }
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.gray.opacity(0.2))
//                            .frame(maxWidth: .infinity)
//                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        HStack {
                            Text("Jornadas")
                                .font(.title2)
                                .bold()
                            
                            
                            Spacer()
                            
                            //                        Button {
                            //
                            //                        } label: {
                            //                            Image(systemName: "plus")
                            //                        }
                        }
                        .padding(.horizontal)
                        
                        List {
                            
                            
                            NavigationLink("djk") {
                                
                            }
                            NavigationLink("djk") {
                                
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        
                        
                    }
                    // Tag Rectangle...
                    VStack {
                        HStack {
                            Text("Etiquetas")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            
                            Text("#Todas as etiquetas")
                                .font(.caption)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                }
                            
                            ForEach(0..<2, id: \.self) { tag in
                                Text("#ABC")
                                    .font(.caption)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.2))
                                    }
                                
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                        }
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    
                    //                    // Indicador do mês
                    //                    HStack {
                    //                        Text("Junho")
                    //                            .font(.title2)
                    //                            .fontWeight(.semibold)
                    //                            .foregroundColor(.primary)
                    //
                    //                        Spacer()
                    //                    }
                    //                    .padding(.horizontal)
                    
                    //                    // Lista de pensamentos
                    //                    List {
                    //                        // Pensamento clicável
                    //                        // Adicione mais pensamentos aqui..
                    //                        //TODO: Colocar entre parênteses as frases.
                    //                        ForEach(viewModel.thoughts, id: \.id) { thought in
                    //
                    //                                ThoughtView(
                    //                                    thought: thought.thought,
                    //                                    dateTime: "11/06/1012 às 09:30",
                    //                                    tag: "Lembrete"
                    //                                )
                    //                                //.padding(.horizontal)
                    //                                .overlay(
                    //                                    NavigationLink(
                    //                                        destination: DetailedThoughtView(
                    //                                            thought: thought.thought,
                    //                                            dateTime: "11/06/1012 às 09:30",
                    //                                            tag: "Lembrete",
                    //                                            additionalNotes: "Focar nos conceitos de State, Binding e Navigation."
                    //                                        )
                    //                                    ) {
                    //                                        EmptyView()
                    //                                    }
                    //                                    .opacity(0)
                    //                                )
                    //                                //.contentShape(Rectangle())
                    //
                    //
                    //                            .buttonStyle(PlainButtonStyle())
                    //                            .swipeActions(edge: .trailing) {
                    //                                Button("Excluir") {
                    //                                    // Ação de excluir
                    //                                }
                    //                                .tint(.red)
                    //
                    //                                Button("Favoritar") {
                    //                                    // Ação de favoritar
                    //                                }
                    //                                .tint(.yellow)
                    //                            }
                    //                            .swipeActions(edge: .leading) {
                    //                                Button("Compartilhar") {
                    //                                    // Ação de compartilhar
                    //                                }
                    //                                .tint(.green)
                    //
                    //                                Button("Editar") {
                    //                                    // Ação de editar
                    //                                }
                    //                                .tint(.blue)
                    //                            }
                    //
                    //                        }
                    //                    }
                    //                    .listStyle(.plain)
                    
                }
                .sheet(isPresented: $showSheet) {
                    // Deprecated - use new views instead
                }
                .toolbar {
                    // Aqui eu quero um header pra eu poder filtrar e classificar todos os pensamentos.
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            
                        } label: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 32, height: 32)
                        }
                    }
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
                            
                            Button {
                                
                            } label: {
                                Text("Adicionar jornada")
                            }
                            
                        }
                    }
                    
                }
            }
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

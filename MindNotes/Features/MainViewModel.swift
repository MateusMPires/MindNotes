//
//  HomeViewModel.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 01/08/25.
//

import Foundation

/*
 AÇÕES:
 
 - Filtrar de frases
 - Carregar e mostrar frases
 
 */

class MainViewModel: ObservableObject {
    
    @Published var thoughts: [Thought] = [
        Thought(thought: "Se ame mais", date: Date(), isFavorite: false, shouldRemind: false)
    ]
    
    func addThought(_ thought: Thought) {
        self.thoughts.append(thought)
    }
    
    func updateThought(_ thought: Thought) {
        
    }
}

//
//  MainViewModel.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 01/08/25.
//

import Foundation

// DEPRECATED: This file is kept for compatibility
// Use ThoughtViewModel and JourneyViewModel instead

class MainViewModel: ObservableObject {
    @Published var thoughts: [Thought] = []
    
    func addThought(_ thought: Thought) {
        // Deprecated - use ThoughtViewModel instead
    }
    
    func updateThought(_ thought: Thought) {
        // Deprecated - use ThoughtViewModel instead
    }
}

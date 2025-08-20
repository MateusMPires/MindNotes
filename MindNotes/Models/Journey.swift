//
//  Journey.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import Foundation
import SwiftData

@Model
class Journey {
    var id: UUID
    var name: String
    var notes: String?
    var emoji: String
    var colorHex: String
    var createdDate: Date
    var isArchived: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \Thought.journey)
    var thoughts: [Thought]?
    
    init(name: String, emoji: String = "📝", colorHex: String = "#007AFF") {
        self.id = UUID()
        self.name = name
        self.notes = nil
        self.emoji = emoji
        self.colorHex = colorHex
        self.createdDate = Date()
        self.isArchived = false
        self.thoughts = []
    }
    
    // MARK: - Essential Methods
    
    func addThought(_ thought: Thought) {
        thought.journey = self
        if thoughts == nil {
            thoughts = []
        }
        thoughts?.append(thought)
    }
    
    func removeThought(_ thought: Thought) {
        thoughts?.removeAll { $0.id == thought.id }
        thought.journey = nil
    }
    
    func toggleArchived() {
        isArchived.toggle()
    }
    
    // MARK: - Computed Properties
    
    var thoughtCount: Int {
        thoughts?.count ?? 0
    }
    
    var activeThoughtCount: Int {
        thoughts?.filter { !$0.isCompleted }.count ?? 0
    }
    
    var favoriteThoughtCount: Int {
        thoughts?.filter { $0.isFavorite }.count ?? 0
    }
    
    var sortedThoughts: [Thought] {
        thoughts?.sorted { $0.createdDate > $1.createdDate } ?? []
    }
    
    var lastThought: Thought? {
        thoughts?.max { $0.createdDate < $1.createdDate }
    }
    
    var hasActiveReminders: Bool {
        thoughts?.contains { $0.hasActiveReminder } ?? false
    }
}

// MARK: - Predefined Journeys
extension Journey {
    static let defaultJourneys = [
        Journey(name: "Reflexões Pessoais", emoji: "🤔", colorHex: "#FF9500"),
        Journey(name: "Objetivos", emoji: "🎯", colorHex: "#34C759"),
        Journey(name: "Gratidão", emoji: "🙏", colorHex: "#FF2D92"),
        Journey(name: "Aprendizados", emoji: "📚", colorHex: "#5856D6")
    ]
}

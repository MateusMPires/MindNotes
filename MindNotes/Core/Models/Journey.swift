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
    var title: String
    var notes: String?
    var icon: String
    var colorHex: String
    var createdDate: Date
    var endDate: Date?
    var isArchived: Bool
    var overview: String?
    
    @Relationship(deleteRule: .cascade, inverse: \Thought.chapter)
    var thoughts: [Thought]?
    
    init(title: String, notes:String? = nil, icon: String = "", colorHex: String = "#007AFF") {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.icon = icon
        self.colorHex = colorHex
        self.createdDate = Date()
        self.endDate = nil
        self.isArchived = false
        self.thoughts = []
        self.overview = nil
    }
    
    // MARK: - Essential Methods
    
    func addThought(_ thought: Thought) {
        thought.chapter = self
        if thoughts == nil {
            thoughts = []
        }
        thoughts?.append(thought)
    }
    
    func removeThought(_ thought: Thought) {
        thoughts?.removeAll { $0.id == thought.id }
        thought.chapter = nil
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


// MARK: - Predefined Thoughts
extension Journey {
    static let mockData = [
        Journey(title: "Terapia"),
        Journey(title: "Carreira")

    ]
}

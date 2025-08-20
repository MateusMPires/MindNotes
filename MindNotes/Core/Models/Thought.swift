//
//  Thought.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 01/08/25.
//

import Foundation
import SwiftData

@Model
class Thought {
    var id: UUID
    var content: String
    var notes: String?
    var createdDate: Date
    var modifiedDate: Date
    var isFavorite: Bool
    var tags: [String]
    var shouldRemind: Bool
    var reminderDate: Date?
    var isCompleted: Bool
    
    var journey: Journey?
    
    init(
        content: String,
        notes: String? = nil,
        tags: [String] = [],
        shouldRemind: Bool = false,
        reminderDate: Date? = nil,
        createdDate: Date = Date(),
        isFavorite: Bool = false,
        journey: Journey? = nil
    ) {
        self.id = UUID()
        self.content = content
        self.notes = notes
        self.createdDate = createdDate
        self.modifiedDate = createdDate
        self.isFavorite = isFavorite
        self.tags = tags
        self.shouldRemind = shouldRemind
        self.reminderDate = reminderDate
        self.isCompleted = false
        self.journey = journey
    }
    
    // MARK: - Essential Methods
    
    func updateModifiedDate() {
        self.modifiedDate = Date()
    }
    
    func addTag(_ tag: String) {
        let cleanTag = tag.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !cleanTag.isEmpty && !tags.contains(cleanTag) {
            tags.append(cleanTag)
            updateModifiedDate()
        }
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
        updateModifiedDate()
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        updateModifiedDate()
    }
    
    func toggleCompleted() {
        isCompleted.toggle()
        updateModifiedDate()
    }
    
    // MARK: - Computed Properties
    
    var hasActiveReminder: Bool {
        guard shouldRemind, let reminderDate = reminderDate else { return false }
        return reminderDate > Date()
    }
    
    var isRecentlyModified: Bool {
        Calendar.current.isDateInToday(modifiedDate)
    }
}

// MARK: - Predefined Thoughts
extension Thought {
    static let defaultThoughts = [
        Thought(content: "Hello, World!"),
        Thought(content: "Swift is awesome!")
    ]
}

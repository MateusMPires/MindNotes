//
//  SchemaV2.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 07/09/25.
//

//
//  SchemaV2.swift
//  MindNotes
//

import SwiftData
import Foundation

enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Thought.self, Journey.self, ThoughtTag.self]
    }
}

// MARK: - Thought (V2)
extension SchemaV2 {
    @Model
    class Thought {
        var id: UUID
        var content: String
        var notes: String?
        var createdDate: Date
        var modifiedDate: Date
        var isFavorite: Bool
        var shouldRemind: Bool
        var reminderDate: Date?
        var isCompleted: Bool
        
        // 🔹 Novo
      //  @Relationship(deleteRule: .nullify, inverse: \ThoughtTag.thoughts)
        var tags: [ThoughtTag]
        
        // 🔹 Novo
        var isHidden: Bool = false
        
        // 🔹 Novo
        var audioURL: URL?
        
        var chapter: Journey?
        
        init(
            content: String,
            notes: String? = nil,
            tags: [ThoughtTag] = [],
            shouldRemind: Bool = false,
            reminderDate: Date? = nil,
            createdDate: Date = Date(),
            isFavorite: Bool = false,
            chapter: Journey? = nil,
            isHidden: Bool = false,
            audioURL: URL? = nil
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
            self.chapter = chapter
            self.isHidden = isHidden
            self.audioURL = audioURL
        }
        
        func updateModifiedDate() {
            self.modifiedDate = Date()
        }
        
        func toggleFavorite() {
            isFavorite.toggle()
            updateModifiedDate()
        }
        
        func toggleCompleted() {
            isCompleted.toggle()
            updateModifiedDate()
        }
        
        var hasActiveReminder: Bool {
            guard shouldRemind, let reminderDate = reminderDate else { return false }
            return reminderDate > Date()
        }
        
        var isRecentlyModified: Bool {
            Calendar.current.isDateInToday(modifiedDate)
        }
    }
}

// MARK: - ThoughtTag (V2)
extension SchemaV2 {
    @Model
    class ThoughtTag {
        @Attribute(.unique) var id: UUID
        var title: String
        
        // 🔹 Novo: inverso
        @Relationship(deleteRule: .nullify, inverse: \Thought.tags)
        var thoughts: [Thought]
        
        init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
            self.thoughts = []
        }
    }
}

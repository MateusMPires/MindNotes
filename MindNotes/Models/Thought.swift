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
        journey: Journey? = nil,
        tags: [String] = [],
        shouldRemind: Bool = false,
        reminderDate: Date? = nil,
        createdDate: Date = Date(),
        isFavorite: Bool = false
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
    
    func updateModifiedDate() {
        self.modifiedDate = Date()
    }
}

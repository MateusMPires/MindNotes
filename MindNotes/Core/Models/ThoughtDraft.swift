//
//  ThoughtDraft.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 12/08/25.
//

import Foundation

struct ThoughtDraft {
    var content: String = ""
    var notes: String = ""
    var createdDate: Date = Date()
    var modifiedDate: Date = Date()
    var isFavorite: Bool = false
    var tags: [ThoughtTag] = []
    var shouldRemind: Bool = false
    var reminderDate: Date = Date()
    var isCompleted: Bool = false
    
    var chapter: Journey? = nil

}

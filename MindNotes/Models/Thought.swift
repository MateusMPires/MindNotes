//
//  Thought.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 01/08/25.
//

import Foundation

struct Thought {
    var id = UUID()
    var thought: String
    var notes: String?
    var date: Date
    var isFavorite: Bool
    var tags: [String]?
    var shouldRemind: Bool
}

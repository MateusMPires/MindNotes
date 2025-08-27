//
//  Tag.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 26/08/25.
//

import Foundation
import SwiftData

@Model
class ThoughtTag {
    @Attribute(.unique) var id: UUID 
    var title: String
    
    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
    
}

//
//  Schema.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import SwiftData

enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Thought.self, Journey.self]
    }
}


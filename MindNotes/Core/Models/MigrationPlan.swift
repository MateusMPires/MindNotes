//
//  MigrationPlan.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 07/09/25.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {    
    
    static var stages: [MigrationStage] {
        [
            MigrationStage.lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self)
        ]
    }
    
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }
}

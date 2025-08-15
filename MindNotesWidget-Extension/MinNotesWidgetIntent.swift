//
//  MinNotesWidgetIntent.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 12/08/25.
//


import AppIntents

struct OpenNewThoughtIntent: AppIntent {
    static var title: LocalizedStringResource = "Adicionar Novo Pensamento"

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

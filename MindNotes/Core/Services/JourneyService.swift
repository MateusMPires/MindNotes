//
//  JourneyService.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import Foundation
import SwiftData
import SwiftUI

class JourneyService: ObservableObject {
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    
    func saveJourney(title: String,
                        notes: String? = nil,
                        icon: String,
                        color: Color,
                     journey: Journey? = nil) {
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let journey = journey {
            // Edita jornada existente
            journey.title = trimmedTitle
            journey.notes = notes
            journey.icon = icon
            journey.colorHex = color.toHex()
        } else {
            // Cria nova jornada
            let newJourney = Journey(
                title: trimmedTitle,
                notes: notes,
                icon: icon,
                colorHex: color.toHex()
            )
            context.insert(newJourney)
        }
        
        // Salva no contexto
        do {
            try context.save()
        } catch {
            print("Erro ao salvar jornada: \(error)")
        }
    }

  func deleteJourney(_ journey: Journey) {
        withAnimation(.easeInOut(duration: 0.3)) {
            context.delete(journey)
            do {
                try context.save()
            } catch {
                print("Erro ao excluir jornada: \(error)")
            }
        }
    }
    
   func archiveJourney(_ journey: Journey) {
        withAnimation(.easeInOut(duration: 0.3)) {
            journey.isArchived = true
            do {
                try context.save()
            } catch {
                print("Erro ao arquivar jornada: \(error)")
            }
        }
    }
    
    func unarchiveJourney(_ journey: Journey) {
        withAnimation(.easeInOut(duration: 0.3)) {
            journey.isArchived = false
            do {
                try context.save()
            } catch {
                print("Erro ao desarquivar jornada: \(error)")
            }
        }
    }
}

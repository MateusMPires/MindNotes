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
    
    func fetchJourneys() -> [Journey] {
        let descriptor = FetchDescriptor<Journey>(
            sortBy: [SortDescriptor(\.title, order: .forward)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Erro ao buscar jornadas: \(error)")
            return []
        }
    }

    
    func saveJourney(title: String,
                        notes: String?,
                        icon: String,
                        color: Color
                     ) {
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
       
            // Cria nova jornada
            let newJourney = Journey(
                title: trimmedTitle,
                notes: notes,
                icon: icon,
                colorHex: color.toHex()
            )
            context.insert(newJourney)
        
        
        // Salva no contexto
        do {
            try context.save()
        } catch {
            print("Erro ao salvar jornada: \(error)")
        }
    }
    
    func editJourney(_ journey: Journey) {
        
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

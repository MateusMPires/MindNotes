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
    
    
    func saveJourney(_ name: String, _ selectedEmoji: String, _ selectedColor: Color, journey: Journey? = nil) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let journey = journey {
            // Edit existing journey
            journey.name = trimmedName
            journey.emoji = selectedEmoji
            journey.colorHex = selectedColor.toHex()
        } else {
            // Create new journey
            let newJourney = Journey(
                name: trimmedName,
                emoji: selectedEmoji,
                colorHex: selectedColor.toHex()
            )
            
            context.insert(newJourney)
            
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

//
//  JourneyViewModel.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import Foundation
import SwiftUI

@MainActor
class JourneyViewModel: ObservableObject {
    @Published var journeys: [Journey] = []
    @Published var selectedJourney: Journey?
    @Published var showingCreateJourney = false
    @Published var showingArchived = false
    
    private let dataManager = DataManager.shared
    
    init() {
        loadJourneys()
    }
    
    func loadJourneys() {
        journeys = dataManager.fetchJourneys(includeArchived: showingArchived)
    }
    
    func createJourney(name: String, emoji: String = "📝", colorHex: String = "#007AFF") {
        dataManager.createJourney(name: name, emoji: emoji, colorHex: colorHex)
        loadJourneys()
    }
    
    func updateJourney(_ journey: Journey) {
        dataManager.updateJourney(journey)
        loadJourneys()
    }
    
    func archiveJourney(_ journey: Journey) {
        dataManager.archiveJourney(journey)
        loadJourneys()
    }
    
    func deleteJourney(_ journey: Journey) {
        dataManager.deleteJourney(journey)
        loadJourneys()
        
        // Clear selection if deleted journey was selected
        if selectedJourney?.id == journey.id {
            selectedJourney = nil
        }
    }
    
    func toggleArchivedView() {
        showingArchived.toggle()
        loadJourneys()
    }
}